function s = smallscale(funcname,percent)

if nargin < 2
    percent = 20;
end
funcname=str2func(funcname);
[startpoint endpoint] = mostnonlin(funcname(1:5000),percent);
d=funcname(1:5000);
s = rangezeroone(d(startpoint:endpoint-1));
