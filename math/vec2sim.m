function m = vec2sim(vec)
% m = vec2sim(vec)
% takes a vector describing a similarity space and returns a symmetric
% similarity matrix
% we assume that the vector order is that generated by sim2vec, i.e.,
% the order generated by tril()

% how big is the final space?
% n choose 2 = length(vec). we know the latter, we want the former
% solve for n.
% if nC2=x,  n=0.5+0.5*sqrt(1+8x)
%
% 2007 ddrucker@psych.upenn.edu


msize=0.5+0.5*sqrt(1+8*length(vec));

CornerPoints=find(tril(ones(msize),-1)~=0);
m=zeros(msize);
m(CornerPoints)=vec;
m=m+m';