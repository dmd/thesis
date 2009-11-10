function output = colstrcaseeven(lab_startpoint,stepsize,n)
% function colstrcaseeven(lab_startpoint,stepsize,n)
% starting point: lab_startpoint
% stepsize: how long to the next
% n: how many steps
%
% 2007 ddrucker@psych.upenn.edu


Lch = applycform(lab_startpoint,makecform('lab2lch'));
L = Lch(1);
C = Lch(2);

output=zeros(n,3);

% what is the first point?

output(1,:)=lab_startpoint;

% what is each subsequent point?

for i=2:n
    thispoint=output(i-1,2:3);
    nextpoint=circleintersect(thispoint,stepsize,[0 0],C,'r');
    output(i,:)=[L nextpoint];
end
