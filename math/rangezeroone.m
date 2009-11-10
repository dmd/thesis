function newvec = rangezeroone(vec)
% FUNCTION NEWVEC = RANGEZEROONE(VEC)
% rescales a vector to be in [0,1]

newvec = vec - min(vec);
newvec = newvec./max(newvec);