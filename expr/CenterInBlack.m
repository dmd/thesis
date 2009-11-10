function placed = CenterInBlack(bw,heightwidth,graycolor)
% PLACED = CENTERINBLACK(BW,HEIGHTWIDTH,GRAYCOLOR)
% given a single plane image, centers it in a black img of size HEIGHT and WIDTH
%
% if GRAYCOLOR is specified, use that instead of black 
% 2007 ddrucker@psych.upenn.edu


placed=zeros(heightwidth);

if nargin == 4
    assert(length(graycolor)==1);
    placed(:)=graycolor;
end


Ystart = round(heightwidth(1)/2 - size(bw,1)/2);
Xstart = round(heightwidth(2)/2  - size(bw,2)/2);
placed(Ystart:Ystart+size(bw,1)-1,Xstart:Xstart+size(bw,2)-1) = bw;
