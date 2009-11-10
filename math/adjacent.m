function s = adjacent(distmat,stim,varargin)
% s = ADJACENT(DISTMAT,STIM, HOWFAR, INVERSE)
% returns the stimuli numbers which are HOWFAR or less away in the space from STIM
% if INVERSE is true, returns those cells in the distance matrix which have a distance of HOWFAR
% or less but are NOT near STIM
% 2007 Daniel M. Drucker ddrucker@psych.upenn.edu

defaultValues = {1.5,false};
nonemptyIdx = ~cellfun('isempty',varargin);
defaultValues(nonemptyIdx) = varargin(nonemptyIdx);
[howfar inverse] = deal(defaultValues{:});

distmat=tril(distmat);
allbut = setdiff(1:length(distmat),stim);
if inverse
    distmat(stim,:) = 0;
    distmat(:,stim) = 0;
else
    distmat(allbut,allbut) = 0;
end
distmat(distmat>=howfar) = 0;
[i,j] = find(distmat);
s = sort([i j],2);
