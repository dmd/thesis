function k = FindKeyboard()
% find the USB keyboard device numbers%
% 2007 ddrucker@psych.upenn.edu

ListenChar(2);
devices=PsychHID('Devices');
kbs=find([devices(:).usageValue]==6);
disp 'please press a key'

%KbWait for multiple devices
found=0;
while ~found;
    for i=1:length(kbs)
        if KbCheck(kbs(i))
            k=kbs(i);
            found=1;
        end
    end
    WaitSecs(0.001)
end

% do not pass control back until the key has been released
while KbCheck(k)
    WaitSecs(0.001);
end
ListenChar(0);