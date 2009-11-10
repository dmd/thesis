function imps=makeallimpulse(n)
% IMPS=MAKEALLUMPULSE(N)
% The all the nxn impulse matrices 

% how big is the vector?
vlen = length(sim2vec(zeros(n)));


imps = {};

for i=1:vlen
    base = zeros(vlen,1);
    base(i)=1;
    imps{i}=vec2sim(base);
end