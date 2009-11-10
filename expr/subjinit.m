function s = subjinit(id)
% S = SUBJINIT(ID) 
% transforms a 6 digit aguirre lab id into initials

if size(id) == [1 8]
    s = [id(1) id(8)];
else
    error('not an aguirre id');
end
