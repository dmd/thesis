function areaonleft = areaonleft(img,targetcolor,linecolor)
% AREAONLEFT = AREAONLEFT(IMG,TARGETCOLOR,LINECOLOR)
%
% IMG           MxN bitmap
% TARGETCOLOR   the value to count occurences of 
% LINECOLOR     value making up the line separating left from right
%
% 2007 ddrucker@psych.upenn.edu

if nargin == 1
    targetcolor = 0;
    linecolor = 255;
end

areaonleft=0;
for row=1:size(img,1)
    linepos = find(img(row,:)==linecolor);
    areaonleft = areaonleft + sum(img(row,1:linepos)==targetcolor);
end
