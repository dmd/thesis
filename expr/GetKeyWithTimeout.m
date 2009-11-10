function [choice,RT] = GetKeyWithTimeout(timeout,allowedkeys)
% RT = GetSameDiff(timeout,allowedkeys)
%
% waits for a response, and returns the choice and RT when it gets it
% or returns -999,-999 if timeout seconds pass
%
% 2007 ddrucker@psych.upenn.edu

global KEYBOARD_DEVICE;
baseTime = GetSecs;
RT=-999;
choice=-999;
gotgood=false;
if nargin==2
    allowedkeys=strcat(allowedkeys,'q');
end

while ~gotgood
    % while no key is pressed, wait until timeout is reached


    %    while ~KbCheck(KEYBOARD_DEVICE)
    if (GetSecs-baseTime) > timeout
        choice=-999;
        RT=-999;
        return;
    end
    WaitSecs(0.001);
    %    end

    % got here? a key is down! retrieve the key and RT
    [keyIsDown, secs, keyCode] = KbCheck(KEYBOARD_DEVICE);
    key = KbName(keyCode);
    if (nargin==1 && keyIsDown) || (exist('allowedkeys','var') && total(ismember(key,allowedkeys)))
        gotgood=true;
    end
end
RT = secs-baseTime;
% if they pressed two keys at the same time, we'll say they pressed the
% wrong key. we assume that '@' is the wrong key :)
if iscell(key)
    key = '@';
end
if (key == 'q')
    GiveBackTheScreen;
    error('experimenter terminated by pressing q');
else
    choice = key;

end

% do not pass control back until the key has been released
while KbCheck(KEYBOARD_DEVICE)
    WaitSecs(0.001);
end

end
