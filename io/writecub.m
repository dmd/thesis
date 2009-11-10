function writecub(filename,cub)
% WRITECUB(FILENAME,CUB)
% writes a minimal-header VoxBo cub file, without needing SPM.
% 2008 Daniel M. Drucker ddrucker@psych.upenn.edu

if ndims(cub) ~= 3
    error('the cub is not 3D');
end
ext = '.cub';
if ~strendswith(filename,ext),
    filename = [filename ext];
end
fid = fopen(filename,'w','b');

%% write the header
fprintf(fid,'VB98\nCUB1\n');
fprintf(fid,'DataType:\tDouble\n');
fprintf(fid,'VoxDims(XYZ):\t%.4f\t%.4f\t%.4f\n',size(cub));
% header terminates with a form feed-newline
fprintf(fid,'%c\n',12);

%% write the data

fwrite(fid,cub,'double');

fclose(fid);
