function [RGB] = lab2rgb(Lab)
% function [RGB] = lab2rgb(Lab)
% Lab2RGB takes L*a*b* in CIELab space
% and transforms them into sRGB using the Image Processing Toolbox
%
% 2007 ddrucker@psych.upenn.edu


RGB = floor(   lab2srgb(Lab)  .*255);
