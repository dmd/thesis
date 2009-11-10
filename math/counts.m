function c = counts(vec)
% C = COUNTS(VEC)
%
% Like hist but without bins - just the original values

% just in case we're handed something non-1D
vec = vec(:);

c1 = unique(sort(vec));
c2 = histc(vec,c1);
c = [c1 c2];
