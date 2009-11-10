function n = pair2num(i,j,s)
% N = PAIR2NUM(S)

if nargin<3; s=16; end;

x=vec2sim(1:((s*(s-1))/2));
n=x(i,j);
