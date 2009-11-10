function vec = readref(filename)
% vec = readref(filename)
% loads a voxbo-style numerical .ref file into a vector, ignoring comments
%
% 2007 ddrucker@psych.upenn.edu

ext = '.ref';
if ~strendswith(filename,ext),
    filename = [filename ext];
end
fh=fopen(filename);
veccell=textscan(fh,'%f','commentStyle',';');
vec=veccell{1};
fclose(fh);
end
