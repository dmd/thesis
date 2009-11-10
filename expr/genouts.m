function outs = genouts(seqs,runs,pad)
% OUTS = GENOUTS(SEQS,RUNS,PAD)
% each column of SEQS should be a sequence.
% this will divide it into RUNS runs and add the duplicate padding
% if PAD is omitted, assume 10

if nargin<3
    pad=10;
end

fullseq = seqs(:);
seg=length(fullseq)/runs;
prepouts = zeros(seg,runs);

starts=1:seg:length(fullseq);

for i=1:runs
    prepouts(:,i) = fullseq(starts(i):starts(i)+seg-1);
end

% we've repartitioned seqs into RUNS sequences. 
% now we're going to make room for the extra dupes

outs = zeros(seg+pad,runs);
outs(pad+1:end,:) = prepouts;

% I need a matrix containing just the elements we're going to stick on top
prepends=outs(end-pad+1:end,:);

% the bottom of column 1 goes at the top of column 2, so lets rotate to the right
prepends=circshift(prepends,[0 1]);

% now stick it at the top
outs(1:pad,:)=prepends;
