function m = shufflerows(m)
% m = SHUFFLEROWS(m)
% randomly re-orders the rows of the 2-D matrix M
% (rows are preserved, columns aren't)
%
% 2007 ddrucker@psych.upenn.edu

if ndims(m) > 2
    error('can only shuffle 1 or 2D matrices');
end


m = m(randperm(length(m)),:);
