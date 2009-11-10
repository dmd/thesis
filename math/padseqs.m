function padded = padseqs(seqs,n)
% PADDED = PADSEQS(MATCHSEQS,N)
% SEQS is a seqlength x numseqs vec; all columns must begin and end
% with the same value
% N is the amount of padding (default 10)
% 

if nargin < 2
    n=10;
end

% make sure input is valid - make sure every element in top and bottom row
% are identical
assert(sum(abs(diff([seqs(1,:) seqs(end,:)]))) == 0,'Not a proper sequence set.');

padded = zeros(size(seqs) + [n 0]);
padded(n+1:end,:) = seqs;

order=[1:size(seqs,2)]';
circ=circshift(order,-1);

padded(1:n,circ) = seqs(end-n+1:end,:);
