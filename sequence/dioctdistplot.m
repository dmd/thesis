function result = dioctdistplot(o,w,dim)
% result = dioctdistplot(o,w,dim)
% original distances vec, warped dist vec
%
% this is completely hardcoded to use the dioct space. passing in distances
% gotten from any other space will yield nonsensical results

o = vec2sim(o);
w = vec2sim(w);

if dim==1
    oA = mean([o(7,15) o(8,9) ]);
    wA = mean([w(7,15) w(8,9) ]);

    oB = mean([o(6,5)  o(15,13)  o(9,11)  o(1,2)]);
    wB = mean([w(6,5)  w(15,13)  w(9,11)  w(1,2)]);
    
    oC = mean([o(13,4) o(11,3)]);
    wC = mean([w(13,4) w(11,3)]);
elseif dim==2
    oA = mean([o(1,9) o(2,11) ]);
    wA = mean([w(1,9) w(2,11) ]);
    
    oB = mean([o(7,8)  o(15,9)  o(11,13)  o(3,4)]);
    wB = mean([w(7,8)  w(15,9)  w(11,13)  w(3,4)]);
    
    oC = mean([o(13,4) o(11,3)]);
    wC = mean([w(13,4) w(11,3)]);
end

oAB = oA + oB;
oAC = oA + oB + oC;
wAB = wA + wB;
wAC = wA + wB + wC;

result = [0 0;oA wA; oAB wAB; oAC wAC;];
