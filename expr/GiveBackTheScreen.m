function GiveBackTheScreen(prej)

if nargin == 0
    prej = false;
end
if prej 
    fprintf('Terminated with extreme prejudice!\n');
end
Priority(0);
Screen('CloseAll');
ShowCursor;
ListenChar;
