function srgb=lab2srgb(lab)
% SRGB = LAB2SRGB(LAB)
% Equivalent to applycform(lab,makecform('lab2srgb'))
%
% 2007 ddrucker@psych.upenn.edu


srgb = applycform(lab,makecform('lab2srgb'));