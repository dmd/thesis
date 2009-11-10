function points = points(degrees,side)
% points = POINTS(degrees,side)
% returns a side x side grid of points rotated by degrees
%
% 2007 ddrucker@psych.upenn.edu

base = [];
for x=1:side
    for y=1:side
        base = [base; x y];
    end
end
points = rotm(mncn(base),degrees);
