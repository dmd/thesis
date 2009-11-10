function out = randfliplr(x,p)
% function out = randfliplr(x)
% fliplr's the rows of x with probability p (default .5)
%
% 2007 ddrucker@psych.upenn.edu

if nargin==1
    p=0.5;
end

for i=1:length(x)
    if rand<p
        x(i,:)=fliplr(x(i,:));
    end
end
out=x;
