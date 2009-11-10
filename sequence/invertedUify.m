function s = invertedUify(vec)
% S = INVERTEDUIFY(VEC)
% applies an inverted U to a vector, output will be in (0,1)
rez=10000;
s = interp1(linspace(min(vec),max(vec),rez),sqrt(1-linspace(-1,1,rez).^2),vec);
