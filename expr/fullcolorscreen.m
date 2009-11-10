function splashcolor = fullcolorscreen(rgbcolor,width,height)
% SPLASHCOLOR = FULLCOLORSCREEN(RGBCOLOR,WIDTH,HEIGHT)
%
% 2007 ddrucker@psych.upenn.edu

if nargin < 3
    error('not enough arguments')
elseif ~ isequal([3,1],size(rgbcolor))
    error('rgbcolor must be of form [x y z]''')
end

u = ones(width,height);

splashcolor = cat(3,u*rgbcolor(1),u * rgbcolor(2),u * rgbcolor(3));
