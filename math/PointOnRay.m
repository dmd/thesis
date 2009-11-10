function M = PointOnRay(K,L,n)
% M = PointOnRay(K,L,n)
% point on the ray KL n units from K
%
% 2003 ddrucker@psych.upenn.edu

M = ((L-K) / distance(K,L) * n) + K;