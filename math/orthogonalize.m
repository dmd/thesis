function orthovec = orthogonalize(G,vec)
% orthovec = orthogonalize(G,vec)
% returns vec orthogonalized with respect to the matrix G
%
% 2007 ddrucker@psych.upenn.edu

vec=shiftdim(vec);
orthovec = vec-(G*getBetas(G,vec));
