function [startpoint endpoint] = mostnonlin(data,percent)
% [startpoint endpoint] = mostnonlin(data,percent)
% returns the range of data which has the highest acceleration
% (highest 1st der)

if nargin < 2
    percent = 20;
end

pts=floor((percent/100)*length(data));

der = abs(diff(data,1));

s=[];
for i = 1:((length(data)-1)-pts)
    s(i) = der(i) - der(i+pts);
end

[m,startpoint] = max(s);
endpoint = startpoint+pts;

%plot(data);
%hold on;
%plot(startpoint:endpoint,data(startpoint:endpoint),'r','LineWidth',2);
%hold off;
