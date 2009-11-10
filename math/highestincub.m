function cub = highestincub(cub,NumVox)
% CUB = HIGHESTINCUB(CUB,NUMVOX)
%
% Given a matrix (usually a cub), returns it where all but the highest
% NUMVOX values have been set to 0
%
% 2008-09 allow NumVox > cub size so we can disable this
% 2007 ddrucker@psych.upenn.edu

if nargin < 2
    NumVox = 50;
end

if NumVox < numel(cub)
    vals=sort(cub(:));
    thresh=vals(length(vals)-NumVox);
    cub=cub>thresh;
else
    warning('NumVox > cub size, not thresholding');
    cub(:)=true;
end
