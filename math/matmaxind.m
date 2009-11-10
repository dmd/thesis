function [r,c] = maxmatind(m)
% [R,C] = MAXMATIND(M)
% returns the row and column of the maximum value in M
% if there are multiple equal maximums, returns the first
% this works around a bug in some old Matlab versions of find
% 2007 ddrucker@psych.upenn.edu

if length(size(m)) ~= 2
    error('matrix must be 2D');
end

[y,i] = max(m(:));
[r,c] = ind2sub(size(m),i);

