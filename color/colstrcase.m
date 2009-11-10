function output = colstrcase(L, C, dist, n, step, phi)
% function output = colstrcase(L, C, dist, n, [step], [phi])
%
% The intention behind this function is to give an output of points in
% L*a*b* color space that vary with respect to hue but maintain a constant
% lightness and chroma.
%
%
% Input
%
% L    = Lightness Level in L*a*b* space.
% C    = Chroma level, defined as sqrt(a^2+b^2)
% dist = The Euclidean distance in L*a*b* space between the first two
%        colors.
% n    = The total number of steps in the staircase between the two points.
% step = The size multiplier for each step. Default is 1.5;
% phi  = The hue angle in radians on the constant C circle to start from.
%            Default is 0.
%
% 2007 ddrucker@psych.upenn.edu

%% Checking Limits
if nargin==4
    step=1.5;
    phi=0;
elseif nargin==5
    phi=0;
elseif nargin~=6
    error('Number of arguments must be 4, 5, or 6');
end

%% Computing points in L*a*b* space

output=zeros(n,3);

% what is the first point? 

output(1,:)=[L C*sin(phi) C*cos(phi)];

% what is each subsequent point?

for i=2:n
    thispoint=output(i-1,2:3);
    nextpoint=circleintersect(thispoint,dist,[0 0],C,'r');
    output(i,:)=[L nextpoint];
    dist = dist * step;
end
