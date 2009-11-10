function crossfadedframe = fadetwoframes(frame1,frame2,t,stepperfunction)
% CROSSFADEDFRAME = FADETWOFRAMES(FRAME1,FRAME2,T,[STEPPERFUNCTION])
%
% 2007 ddrucker@psych.upenn.edu

if nargin < 4 | isempty(stepperfunction)
    stepperfunction = @(x) x;
end

crossfadedframe = (1-stepperfunction(t)).*frame1 + stepperfunction(t).*frame2;

end