function ShowFixationCross(w,par)
Screen(w,'FillRect',par.bgcolor);
DrawFormattedText(w, '+', 'center', 'center', 0);
Screen('Flip',w);
pause(par.ITI);
end