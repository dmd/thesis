function cropped = cropbwimage(bwimage)
% function cropped = cropbwimage(bwimage)
% takes a logical image
% returns the logical image cropped to fit 
%
% 2007-11 use regionprops to do the work
% 2007 ddrucker@psych.upenn.edu

rp = regionprops(bwlabel(bwimage),'FilledImage');
cropped = rp.FilledImage;

