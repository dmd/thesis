function [perf actualdistance] = distaccconf(space,guesses,desireds,iters)
% p = distaccconf(space,guesses,desireds)
% returns the % of random norm dists less than what we got
% 2009 ddrucker@psych.upenn.edu
actualdistance = norm(simdist(space,guesses,desireds));
nstims=max(desireds);
iters=2000;
perms=zeros(1,iters);
for i=1:iters
    perms(i)=norm(simdist(space,ceil(nstims.*rand(length(guesses),1))',desireds));
end
perf=sum(actualdistance > perms)/iters;
