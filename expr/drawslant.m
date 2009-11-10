function img = drawslant(img, p1, degrees, linecolor, dontmask)
% IMG = DRAWSLANT(IMG, POINT, DEGREES, LINECOLOR, DONTMASK)
%
% IMG is a MxN or MxNx3 bitmap
% POINT is a point that the line goes through
% degrees is deviation from vertical
%
% 2007 ddrucker@psych.upenn.edu

if nargin < 4
    linecolor = 255;
end
if nargin < 5
    dontmask = false;
end

border=40;

assert((size(img,3) == 1) || (size(img,3) == 3));

if size(p1,2) == 3
    p1 = p1(1:2);
end

%% we only care about the first plane right now
s = size(img);
s = s(1:2);

if strcmp(p1,'center')
    p1 = s/2;
end

%% find the boundary point to draw the line through

p2(1) = 0;
p2(2) = p1(2)  +   p1(1)*tand(degrees);
ind = drawline(p1,p2,s);
p3(1) = size(img,1);
p3(2) = p1(2) - p1(1)*tand(degrees);
ind2 = drawline(p1,p3,s);
lineimg = zeros(s);
lineimg([ind ind2])=1;

%% create the mask that will be applied to the lineimg

if ~dontmask
     se = strel('line',border,90-degrees);
     blobmask = imdilate(~im2bw(img),se);
     lineimg = lineimg.*~blobmask;
    
end

%% clear the mask within the bounding box
maskidx = find(lineimg==1);

%% write to all planes
% ind and ind2 contain the linear indices AS IF we had a single-plane
% image. what if we don't?

if size(img,3) == 3
    if length(linecolor) == 1, linecolor=repmat(linecolor,3,1); end
    for plane=0:2
        img(maskidx+plane*prod(s))=linecolor(plane+1);
    end
elseif size(img,3) == 1
    img(maskidx)=linecolor;
end
