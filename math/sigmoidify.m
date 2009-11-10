function s = sigmoidify(vec)
% S = SIGMOIDIFY(VEC)
% applies a sigmoid to a vector, output will be in (0,1)
rez=500;
s = interp1(linspace(min(vec),max(vec),rez),1./(1+exp(-linspace(-6,6,rez))),vec);
