function zt = ztransform(d)
% ZT = ZTRANSFORM(D)
% the z-transformation of D
%
% 2007 ddrucker@psych.upenn.edu

zt=mncn(d);
zt=zt/std(reshape(zt,1,numel(zt)));
end
