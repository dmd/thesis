function writetes(filename,tes)
% WRITETES(FILENAME,TES)
% writes a minimal-header VoxBo tes file
% the input tes should be [T X Y Z]
% 2009 Daniel M. Drucker ddrucker@psych.upenn.edu

if ndims(tes) ~= 4
    error('the tes is not 4D');
end

ext = '.tes';
if ~strendswith(filename,ext),
    filename = [filename ext];
end
fid = fopen(filename,'w','b');
% write the header
fprintf(fid,'VB98\nTES1\n');
fprintf(fid,'DataType:\tDouble\n');
fprintf(fid,'VoxDims(TXYZ):\t%d\t%d\t%d\t%d\n',size(tes));

% header terminates with a form feed-newline
fprintf(fid,'%c\n',12);


% a tes starts with a uint8 mask. find where tes is not zero across all
% cubs, and write the mask
mask = squeeze(logical(sum(abs(tes))~=0));
fwrite(fid,mask,'uint8');

% write the data
% make the mask images-deep in the 4th dim
mask = repmat(mask,[1 1 1 size(tes,1)]);
fwrite(fid,tes(mask),'double');

fclose(fid);
