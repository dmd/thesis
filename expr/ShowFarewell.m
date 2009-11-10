function ShowFarewell(w,par)
% function ShowFarewell(w,par)
Screen('TextSize',w, 24);
Screen(w,'FillRect',par.bgcolor);
DrawFormattedText(w, 'Thank you! The experiment is complete.\nPlease open the door of the experiment room to signal that you are done.', 'center', 'center', 0);
Screen('Flip',w);
GetKeyWithTimeout(999);
end