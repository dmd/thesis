function r = WaitForRespWithTimeout(timeout)
% status = WaitForRespWithTimeout(timeout)
%
% waits for a buttonbox press, and returns it gets it
% or returns false if timeout seconds pass
%
% 2007 ddrucker@psych.upenn.edu


baseTime = GetSecs;
r=false;
while ((GetSecs - baseTime) < (timeout))
    r=CheckForResp;
    if r
        break;
    end
    WaitSecs(0.001); % give the CPU a quick breather
end
