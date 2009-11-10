function s = mncnsim(s)
% S = MNCNSIM(S)
% mean centers a symmetric matrix, using only the lower triangle

s=vec2sim(mncn(sim2vec(s)));
