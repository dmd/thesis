function fff = gaussmapper(invalue)
% FFF = GAUSSMAPPER(INVALUE)
% gaussian xform
% 2007 ddrucker@psych.upenn.edu


%a =1; b=1; c=1;
fff = [];
x = invalue .* 2 -1;
%fff = a*exp(-1*(x-b).^2/c.^2);
fff = exp(-1*(x-1) .^ 2 / 1 .^ 2);

end