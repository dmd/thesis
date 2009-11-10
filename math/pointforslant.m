function column = pointforslant(img,angle,offset,targetcolor,linecolor)
% COLUMN = POINTFORSLANT(IMG,ANGLE,OFFSET,TARGETCOLOR,LINECOLOR)
%
% IMG         MxN bitmap 
% ANGLE       desired tilt of line
% OFFSET      -1 or 1 for left or right
% TARGETCOLOR the value for the blob (default 0)   | neither or both must
% LINECOLOR   the value of the line (default 255)  | be specified
%
% 2007 ddrucker@psych.upenn.edu

if nargin == 3
    targetcolor = 0;
    linecolor = 255;
end

if size(img,3) == 3
    img=img(:,:,1);
end
stats=regionprops(double(~img));
Atot = stats.Area;

assert(abs(offset)==1); % offset just says -1 or 1
amount = 0.15; % gives .35 / .65
offset = 0.5 + amount*offset;

% start drawing from the middle row
row = size(img,1)/2;

column = floor(fminbnd(@(col) abs(areaonleft(drawslant(img,[row col],angle,linecolor,true),targetcolor,linecolor)/Atot - offset),1,size(img,2)));
