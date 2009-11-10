function d = GenTestMat(varargin)
% D = GENTESTMAT(POINTSLIST,DEGREES,MINKEXPONENT)
% degrees is the assumed rotation of axes
% size(pointslist,2) must = 2
% pointslist defaults to a 4x4 square linear grid
% degrees defaults to 0
% minkexponent defaults to 2, specifies the mink power for MinkVec
%
% 2008-08 added minkexponent
% 2007 ddrucker@psych.upenn.edu


defaultValues={points(0,4),0,2};
nonemptyIdx = ~cellfun('isempty',varargin);
defaultValues(nonemptyIdx) = varargin(nonemptyIdx);
[d.pointslist degrees minkexponent] = deal(defaultValues{:});

%% generate matrices
p=mncn(d.pointslist(:,1));
q=mncn(d.pointslist(:,2));
d.OrderG=nchoosek(length(p),2);

ext=length(p);

for i=1:ext
    for j=1:ext
        % what is the x,y coordinates of this pair?
        pqnosym = rotm([p(i) q(i)] - [p(j) q(j)],degrees);
        pqdiff = abs(pqnosym);
        d.CityP(i,j)  = pqdiff(1);
        d.CityQ(i,j)  = pqdiff(2);
        d.CityNP(i,j) = pqnosym(1);
        d.CityNQ(i,j) = pqnosym(2);
    end
end

d.City = d.CityP + d.CityQ;
d.CityN = d.CityNP + d.CityNQ;

d.Euclid = vec2sim(getalldistances(d.pointslist,degrees,2)); % degrees doesn't really matter since it's Euclidean
d.Mink = vec2sim(getalldistances(d.pointslist,degrees,minkexponent));
d.Angle  = vec2sim(getallangles(d.pointslist,degrees,45));
d.Angle90 = vec2sim(getallangles(d.pointslist,degrees,90));
d.AngleVec         = sim2vec(d.Angle);
d.Angle90Vec       = sim2vec(d.Angle90);

d.CityVec       = mncn(   sim2vec(d.City)        );
d.CityPVec      = mncn(   sim2vec(d.CityP)       );
d.CityQVec      = mncn(   sim2vec(d.CityQ)       );
d.EuclidVec     = mncn(   sim2vec(d.Euclid)      );
d.MinkVec       = mncn(   sim2vec(d.Mink)        );

%% orthogonalize EuclidVec wrt CityVec to make OrthoEuclidVec
G=zeros(d.OrderG,2);
G(:,1)=1; % intercept
G(:,2)=d.CityVec;
d.OrthoEuclidVec=orthogonalize(G,d.EuclidVec);

