function a = trimean(m,flipsigns)
% function a = trimean(m,flipsigns)
% given a square matrix with zero diagonal, returns the average of the two
% triangles.
% if FLIPSIGNS is true, negate the upper triangle. (This is useful for
% SVM results.)

if nargin<2
    flipsigns = false;
end

if size(m,3) > 1 || size(m,1) ~= size(m,2) 
    error('square matrices only');
end


a = zeros(length(m));

for i=1:length(m)
    for j=1:length(m)
        if i>j
            if flipsigns, m(i,j)=-m(i,j); end;
            a(i,j)=mean([m(i,j) m(j,i)]);
        end
    end
end