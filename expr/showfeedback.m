function showfeedback(correct,w)
if correct == 1
    DrawFormattedText(w, '@ @', 'center', 'center', [0 255 0]);
else
    DrawFormattedText(w, 'XXX', 'center', 'center', [255 0 0]);
end
Screen('Flip',w);
WaitSecs(0.1);
end