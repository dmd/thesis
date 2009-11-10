function [vec] = sim2vec(m)
% [vec] = sim2vec(m)
% takes a square, symmetric similarity matrix and returns a vector
% consisting of a triangular part.
%
% 2007 ddrucker@psych.upenn.edu

% are we square?
if ~ ((ndims(m) == 2) && (size(m,1) == size(m,2)))
    error('matrix must be a square');
end

CornerPoints=find(tril(ones(size(m)),-1));

vec=m(CornerPoints);
