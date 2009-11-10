function d = simdist(space,a,b)
% D=SIMDIST(SPACE,A,B)
% 
% space is a nx2 list of coords for the space
% a and b are vecs of stim numbers
% D is the distance between a(1) and b(1), a(2) and b(2), etc
assert(length(a)==length(b));

d=zeros(1,length(a));
for stim=1:length(a)
    d(stim)=distance(space(a(stim),:),space(b(stim),:));
end