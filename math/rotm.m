function r = rotm(m,degrees)
% R = ROTM(M,DEGREES)
% applies a rotation matrix to m
%
% 2007 ddrucker@psych.upenn.edu

if degrees ==0
    r=m;
else
    t=degrees*pi/180; % reflects the accuracy of the floating point value for pi but we don't care -  it's faster
    r = m*[cos(t)  -sin(t) ; sin(t)  cos(t)];
end