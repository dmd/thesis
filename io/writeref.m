function writeref(filename,vec)
% WRITEREF(FILENAME,VEC)
%
% writes a voxbo-style numerical .ref file 
% including the ;VB98\n;REF\n
%
% 2007 ddrucker@psych.upenn.edu

ext = '.ref';
if ~strendswith(filename,ext),
    filename = [filename ext];
end
vec(abs(vec)<1e-14)=0;
dlmwrite(filename,vec,'\n');
PrependHeader(filename,';VB98\n;REF1\n');
