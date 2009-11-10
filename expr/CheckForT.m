function trExists = CheckForT
% CheckForT
%   Checks to see if a t has occurred.
%
% 2003 ddrucker@psych.upenn.edu

trExists = false;
q=113;
t=116;


% Check to see if a character is available in the queue.
if CharAvail
    [c, w] = GetChar(0, 1);
    if c == t
        trExists = true;
    elseif c == q
        GiveBackTheScreen(true);
        error('Experimenter pressed q to terminate');
    end
    
end

