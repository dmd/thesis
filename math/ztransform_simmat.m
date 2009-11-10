function ztsim = ztransform_simmat(m)
% ZTSIM = ZTRANSFORM_SIMMAT(M)
% ztransforms a square symmetric similarity matrix, keeping the diagonal zero
%
% 2007 ddrucker@psych.upenn.edu

ztsim = vec2sim(ztransform(mncn(sim2vec(m))));
end
