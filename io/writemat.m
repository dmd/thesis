function writemat(filename,mat)
% WRITECUB(FILENAME,MAT)
% writes a minimal-header VoxBo mat file
% 2008 Daniel M. Drucker ddrucker@psych.upenn.edu

if ndims(mat) ~= 2
    error('the mat is not 2D');
end
ext = '.mat';
if ~strendswith(filename,ext),
    filename = [filename ext];
end
fid = fopen(filename,'w','b');

%% write the header
fprintf(fid,'VB98\nMAT1\n');
fprintf(fid,'DataType:\tDouble\n');
fprintf(fid,'VoxDims(XY):\t%.4f\t%.4f\n',size(mat));
% header terminates with a form feed-newline
fprintf(fid,'%c\n',12);

%% write the data

fwrite(fid,mat,'double');

fclose(fid);
