function id = subjectid(initials)
% SUBJECTID  create an Aguirre lab subject identifier
%    id = subjectid(initials) where initials is 'AZ' and the current date
%    is 25 December 2008 returns the string 'A122508Z'
%
% to do - modify to accept a different date
%
% 2007 ddrucker@psych.upenn.edu


initials=strtrim(initials);
if length(initials) ~= 2
    error('expected two letters for initials');
end

id = upper([initials(1) datestr(now,'mmddyy') initials(2)]);