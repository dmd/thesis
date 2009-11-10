function NewVec = CopyVec(Vec,NewLength)
% NewVec = CopyVec(Vec,NewLength)
% returns Vec repeated over and over to make a new vec newlength long
%
% 2007 ddrucker@psych.upenn.edu

NewVec=repmat(Vec,1,ceil(NewLength/length(Vec)));
NewVec=NewVec(1:NewLength);

end
