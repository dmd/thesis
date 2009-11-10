function [p,q] = pqdecomp(p1,p2)

point=p2-p1;
d=distance(p1,p2,2);
p=d*point(1)/sum(point);
q=d*point(2)/sum(point);