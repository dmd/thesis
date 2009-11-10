function status = WaitForTWithTimeout(timeout)
% status = WaitForTWithTimeout(timeout)
%
% waits for a 't', and returns true when it gets it
% or returns false if timeout seconds pass
%
% 2003 ddrucker@psych.upenn.edu


baseTime = GetSecs;
status=false;
while ((GetSecs - baseTime) < (timeout))
    if  CheckForT
        status=true;
        break;
    end
    WaitSecs(0.001); % give the CPU a quick breather
end
