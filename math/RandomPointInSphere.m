function p = RandomPointInSphere(radius,origin)
% RandomPointInSphere ( radius as scalar, origin as [x y z] )
% if no origin given, assumes [0 0 0]
% if no radius or origin given, assumes radius = 1, origin = [0 0 0]
% method: choose random 0 <= theta < 2pi
%               -pi <= phi <= pi
%               0 <= rho <= radius
%
% 2003 ddrucker@psych.upenn.edu

% 2015 NOTE DO NOT USE THIS CODE. IT IS INCORRECT. IT IS BIASED TOWARDS THE POLES.

if nargin==0
    radius = 1;
    origin = [0 0 0];
elseif nargin==1
    origin = [0 0 0];
end

theta = 2*pi * rand;
phi = 2*pi * rand - pi;
rho = radius * rand;

[x,y,z] = sph2cart(theta,phi,rho);
x = origin(1) + x;
y = origin(2) + y;
z = origin(3) + z;
p = [x y z];

if size(origin) == [3 1]
    p=p';
end
