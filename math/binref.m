function r = binref(v)
% r = binref(v)
% converts 1 2 3 1 2 3 into [1 0 0 1 0 0; 0 1 0 0 1 0; 0 0 1 0 0 1]
%
% see also mdsref

if ~isrow(v)
    v=v';
end
r=zeros(max(v),length(v));
for i=unique(v)
    r(i,:)=v==i;
end
