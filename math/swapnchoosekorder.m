function newvec = swapnchoosekorder(vec)
% newvec = swapnchoosekorder(vec)
% 
% changes the order of a sim2vec vector so it goes horiz-first
% instead of vertical-first, or vice versa


msize=0.5+0.5*sqrt(1+8*length(vec));

simmat = zeros(msize);
i=0;
for left = 1:msize
    for right = 1:msize
        if left > right
            i=i+1;
            simmat(left,right) = vec(i);
        end
    end
end

newvec=sim2vec(simmat);
