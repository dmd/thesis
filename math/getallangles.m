function angles = getallangles(points,degrees,modulo)
% angles = getallangles(points,degrees,modulo)
% points is a list of x y coords
% angles is all the angles between the pairs of points
% example:
%   getallangles(points(0,4))
% or
%   load octagon; getallangles(octagon);
%
% 2007 ddrucker@psych.upenn.edu


if nargin == 1
    degrees = 0;
    modulo = 45;
end
if nargin == 2;
    modulo = 45;
end

angles=[];
pairs = nchoosek(1:length(points),2);
points = rotm(points,degrees);
for i=1:length(pairs)
    angles = [angles; modanglebetween(points(pairs(i,1),:),points(pairs(i,2),:),modulo)];
end
