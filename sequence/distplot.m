function result = distplot(opoints,wpoints,dim)
% result = distplot(opoints,wpoints,dim)
% original points, warped points, dimension (1 or 2)



% generate a matrix of distances between points

[o_distsvec,o_xdistsvec,o_ydistsvec]=getalldistances(opoints);
[w_distsvec,w_xdistsvec,w_ydistsvec]=getalldistances(wpoints);

if dim==1, o_dimdistsvec = o_xdistsvec; w_dimdistsvec = w_xdistsvec; end
if dim==2, o_dimdistsvec = o_ydistsvec; w_dimdistsvec = w_ydistsvec; end

% where are the pure changes?
% pures is 0 for composite changes, 1 for pure changes along dimension DIM
pure = getallangles(opoints,0,90) == (dim-1)*90;

% clear out the non-pure distances. only blue-eyed distances allowed!
o_dimdistsvec(pure==0) = 0;
w_dimdistsvec(pure==0) = 0;

o_dimdists=vec2sim(o_dimdistsvec);
w_dimdists=vec2sim(w_dimdistsvec);

% we're going to scatterplot the distances along the chosen dimension.
% the X value on the resulting plot will be the start-position of the
% original point
% the Y value is the SUM of the distance from the origin point
% to the current point and the distance from the current
% point to the other point
i=0;
result = [];
for pair = nchoosek(1:length(opoints),2)'
    i=i+1;
    p1=pair(1);     p2=pair(2);
    
    % is this a pure transition? if not, don't do it
    if ~pure(i), continue; end
    
    % calculate o_basis and w_basis, which are the distances between the
    % start point and the from point
    
    o_basis = opoints(p1,dim) - min(opoints(:,dim));
    w_basis = wpoints(p1,dim) - min(wpoints(:,dim));
    
    result = [result; o_dimdists(p1,p2)+o_basis  w_dimdists(p1,p2)+w_basis];

end
