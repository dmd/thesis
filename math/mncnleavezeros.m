function meancentered = mncnleavezeros(vec)
% MEANCENTERED = MNCNLEAVEZEROS(VEC)
% mean-centers a vector (or matrix), ignoring 0 values (0s stay 0 and are not included
% as part of the calculation of the mean)
%
% 2007 ddrucker@psych.upenn.edu


nonzeros = find(vec~=0);
nz = numel(nonzeros);

sig = sum(vec(nonzeros));
mean = sig/nz;

meancentered = vec;
meancentered(nonzeros) = meancentered(nonzeros)-mean;
