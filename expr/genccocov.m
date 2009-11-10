function covs = genccocov(v,varargin)
% COVS = GENCCOCOV(V,DEGREES,POINTSLIST,USETARGET,CUTOFFFIRST,MINKEXPONENT)
% Generates covariates for a continuous carryover fMRI design (Aguirre 2007) given a set of points and a degrees of assumed axis rotation. 
% V is a list of stimulus ids, including the first CUTOFFFIRST which will be discarded
% DEGREES         default = no rotation (0 deg)
% POINTSLIST      default = 4x4 linearly scaled grid
% USETARGET       default = no target
% CUTOFFFIRST     default = 10
% MINKEXPONENT    default = 2 (applies to adaptMink only)
%
% 2007-9 Daniel M. Drucker ddrucker@psych.upenn.edu

%% initialize default values
defaultValues={0,points(0,4),false,10,2};
nonemptyIdx = ~cellfun('isempty',varargin);
defaultValues(nonemptyIdx) = varargin(nonemptyIdx);
[degrees pointslist usetarget cutofffirst minkexponent] = deal(defaultValues{:});

%% set up template variables
template = zeros(length(v),1);
notzero = find(v~=0);
iszero  = find(v==0);

%% MAIN 
% + where a stimulus is on the screen, - for blanks --> mean-centered
main = template;
main(:) = 1;                       % main is normally +
main(iszero)=-1;                   % main is - if v is 0

%% NEW 
new = template;
new(notzero)=-1;                   % new is - if v is +
new(iszero+1)=1;                   % new is + following v being 0
new(iszero)=0;                     % new is 0 if v is 0, even if the previous element is 0
new = new(1:length(v));            % if last element is 0, don't lengthen

%% REPT
rept = template;
rept(notzero)=-1;                  % - for most stims
rept(find(diff(v)==0)+1)=1;        % 1 for repeats
rept(iszero)=0;                    % 0 for blanks
rept = rept(1:length(v));          % if last element is 0, don't lengthen

%% TARGET
t=0; % how many extra rows/columns do we need, besides the one for blank?
if usetarget
    target = template;
    target(v==max(v)) = 1;         % target is + if v is max
    target(v~=max(v)) = -1;        % target is - otherwise
    target(iszero) = 0;            % target is 0 if v is 0

    % AFTERTARGET
    aftertarget = template;
    aftertarget(notzero) = -1;                % normally -
    aftertarget(find(v==max(v))+1) = 1;       % aftertarget is + AFTER v is max
    aftertarget(iszero) = 0;                  % aftertarget is 0 if v is 0
    aftertarget = aftertarget(1:length(v));   % if last element is 0, don't lengthen

    % general target-related housekeeping 
    notzero = intersect(find(v~=0),find(v~=max(v)));
    t=1;  % we need an extra row/column for target
end

%% direct
% what are the actual direct and adapt effects?
% we need to get this information from GenTestMat

% note that pointslist should NOT contain the target if there is one
d = GenTestMat(pointslist,degrees,minkexponent);

% v is the vector containing the id number of the row/col in GenTestMat's output

directP = template;
directQ = template;
% rotate coords of pointslist
pointslist = rotm(pointslist,degrees)+1;
directP(notzero) = pointslist(v(notzero),1);
directQ(notzero) = pointslist(v(notzero),2);

%% adapt
% i need a (length(v),2) of all the sequence pairs
pairs = [];
pairs(:,1) = v(1:end-1);
pairs(:,2) = v(2:end);
pairs = [0 0 ; pairs];
% and pairs will be indexed by 1, keeping in mind that 1 actually is 0
pairs = pairs + 1;

% matlab, being retarded, can't deal with 0s as indices so we need to
% generate a sim matrix that's off by one

% mean center
d.CityOrig = d.City;
d.City  = mncnsim(d.City);
d.CityP = mncnsim(d.CityP);
d.CityQ = mncnsim(d.CityQ);


% initialize all the matrices we're going to populate
[City CityOrig CityP CityQ CityN CityNP CityNQ Mink Euclid EuclidOrig OrthoEuclid anglemat] = deal(zeros(length(d.pointslist)+t+1));

City(2:end-t,2:end-t)      = d.City;
CityOrig(2:end-t,2:end-t)  = d.CityOrig;
CityP(2:end-t,2:end-t)     = d.CityP;
CityQ(2:end-t,2:end-t)     = d.CityQ;

adapt      = diag(City(pairs(:,1),pairs(:,2)));
adaptOrig  = diag(CityOrig(pairs(:,1),pairs(:,2)));
adapt(new==1)=-9;
adaptOrig(new==1)=-9;
adapt(rept==1)=-5;
adaptOrig(rept==1)=-5;
adaptP     = diag(CityP(pairs(:,1),pairs(:,2)));
adaptQ     = diag(CityQ(pairs(:,1),pairs(:,2)));

CityN(2:end-t,2:end-t)  = d.CityN;
CityNP(2:end-t,2:end-t) = d.CityNP;
CityNQ(2:end-t,2:end-t) = d.CityNQ;

adaptN  = diag( CityN(pairs(:,1),pairs(:,2)));
adaptNP = diag(CityNP(pairs(:,1),pairs(:,2)));
adaptNQ = diag(CityNQ(pairs(:,1),pairs(:,2)));

%% euclidean
OrthoEuclid(2:end-t,2:end-t) = vec2sim(d.OrthoEuclidVec);
adaptOrthoEuclid = diag(OrthoEuclid(pairs(:,1),pairs(:,2)));

%% adaptpairs
% encodes adapt IDs for all 120 pairs of stimuli
apdraw = sort(pairs-1,2);
for i=1:length(apdraw)
    apd(i)={sprintf('%02d_%02d',apdraw(i,1),apdraw(i,2))};
end
saulapd = apd;
apd(iszero)  ={'0'};
%apd(rept==1) ={'0'};
apd(iszero+1)={'0'};
if usetarget
    apd(target==1)  ={'0'};
    apd(aftertarget==1) = {'0'};
end
apd = apd(1:length(v)); % if last element is 0, don't lengthen

%% direction distances
% there are length(unique(round(d.Angle90Vec))) many of these
% their value is the Euclidean distance between the pair if the pair
% is of the matching angle for that cov, 0 elsewhere, and 0 for blanks

% set up all of them
d.EuclidOrig     = d.Euclid;
d.Euclid = mncnsim(d.Euclid);
Euclid(2:end-t,2:end-t)     = d.Euclid;
EuclidOrig(2:end-t,2:end-t) = d.EuclidOrig;
adaptEuclid     = diag(Euclid(pairs(:,1),pairs(:,2)));
adaptEuclidOrig = diag(EuclidOrig(pairs(:,1),pairs(:,2)));
adaptEuclid(new==1)=-9;
adaptEuclidOrig(new==1)=-9;
adaptEuclid(rept==1)=-5;
adaptEuclidOrig(rept==1)=-5;

d.Mink = mncnsim(d.Mink);
Mink(2:end-t,2:end-t) = d.Mink;
adaptMink = diag(Mink(pairs(:,1),pairs(:,2)));

angles = rounddig(d.Angle90,2);                   % interpoint angle matrix
anglemat = anglemat-1;                              % will be -1 for blanks

anglemat(2:end-t,2:end-t) = angles;                % insert the matrix
anglelist = unique(angles);
ddists = zeros(length(v),length(anglelist));   % one cov per unique angle
adaptangle = diag(anglemat(pairs(:,1),pairs(:,2)));  % angle covariate
i=0;
for angle=anglelist'
    i=i+1;
    ddists(:,i) = adaptEuclid;                 % it's the Euclidean distance
    ddists(adaptangle ~= angle,i) = 0;         % but clear it out unless we match the angle.
end

%% prepare output - cut off the first set and mean-center w/o zeros

covs.adapteuorig       =                  adaptEuclidOrig(cutofffirst+1:end) ;
covs.adapteu           = mncnleavezeros(  adaptEuclid(cutofffirst+1:end));
covs.adaptMink         = mncnleavezeros(    adaptMink(cutofffirst+1:end));
covs.main              = mncnleavezeros(         main(cutofffirst+1:end));
covs.new               = mncnleavezeros(          new(cutofffirst+1:end));
covs.rept              = mncnleavezeros(         rept(cutofffirst+1:end));
covs.directP           = mncnleavezeros(      directP(cutofffirst+1:end));
covs.directQ           = mncnleavezeros(      directQ(cutofffirst+1:end));
covs.adaptorig         =                        adaptOrig(cutofffirst+1:end) ;
covs.adapt             = mncnleavezeros(        adapt(cutofffirst+1:end));
covs.adaptP            = mncnleavezeros(       adaptP(cutofffirst+1:end));
covs.adaptQ            = mncnleavezeros(       adaptQ(cutofffirst+1:end));
covs.adaptN            = mncnleavezeros(       adaptN(cutofffirst+1:end));
covs.adaptNP           = mncnleavezeros(      adaptNP(cutofffirst+1:end));
covs.adaptNQ           = mncnleavezeros(      adaptNQ(cutofffirst+1:end));
if usetarget
    covs.target        = mncnleavezeros(       target(cutofffirst+1:end));
    covs.aftertarget   = mncnleavezeros(  aftertarget(cutofffirst+1:end));
end
covs.ddists            =                      ddists(cutofffirst+1:end,:);
covs.adaptOrthoEuclid  = mncnleavezeros(adaptOrthoEuclid(cutofffirst+1:end));
covs.sequence          =                            v(cutofffirst+1:end) ;
covs.apd               =                          apd(cutofffirst+1:end) ;
covs.saulapd           =                      saulapd(cutofffirst+1:end) ;
covs.anglelist         = anglelist;

