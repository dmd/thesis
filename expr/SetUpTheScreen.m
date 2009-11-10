function window = SetUpTheScreen
Screen('Preference', 'SkipSyncTests', 0);
screens=Screen('Screens');
screenNumber=max(screens);
ListenChar(2);
[window,windowRect]=Screen(screenNumber,'OpenWindow',0,[],[],2);
Priority(MaxPriority(window));
HideCursor;
WaitSecs(1); % wait for display to stabilize
end