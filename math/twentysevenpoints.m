function points = twentysevenpoints
% returns 27 points in a cube configuration
%
% 2007 ddrucker@psych.upenn.edu

points = [];

for x=0:2
    for y=0:2
        for z=0:2
            points = [points; [x y z]];
        end
    end
end



        