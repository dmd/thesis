function m = colorcast(im,color)
% M = COLORCAST(IM,COLOR)
% 
% given a grayscale image, makes it black and color instead of black and white.
%
% 2007 Daniel M. Drucker <ddrucker@psych.upenn.edu>

if length(color) ~= 3
    error('color must be a 3 element vector');
end
if size(im,3) ~= 1
    error('image must be grayscale');
end

o=cast(ones(size(im)),class(im));
color=cast(color,class(im));


m(:,:,1)=im .* o.*color(1);
m(:,:,2)=im .* o.*color(2);
m(:,:,3)=im .* o.*color(3);

