function respExists = CheckForResp
% CheckForResp
%   Checks to see if a buttonbox button has occurred.
%
% 2007 ddrucker@psych.upenn.edu

respExists = false;

% define some ASCII codes
q=113;
t=116;
r=114;
b=98;
g=103;
y=121;

% Check to see if a character is available in the queue.
if CharAvail
    [c, w] = GetChar(0, 1);
    if ismember(c,[t r b g y])
        respExists = c;
    elseif c == q
        GiveBackTheScreen(true);
        error('Experimenter pressed q to terminate');
    end
    
end

