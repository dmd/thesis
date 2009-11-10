function [rotdistvec xdists ydists] = getalldistances(pointslist,degrees,minkowski)
% [rotdistvec xdists ydists] = getalldistances(pointslist,degrees,minkowski)
%
% 2009 added hack to get x and y dists
% 2007 ddrucker@psych.upenn.edu

if nargin < 2
    degrees=0;
end

if nargin < 3
    minkowski=1;
end

pointslist=rotm(pointslist,degrees);

rotdistvec = pdist(pointslist,'minkowski',minkowski)';

xdists = pdist(pointslist(:,1))';
ydists = pdist(pointslist(:,2))';
