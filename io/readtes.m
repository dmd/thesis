function [tes,dims] = readtes(filename)
% [TES,DIMS] = READTES(FILENAME)
% read a VoxBo-style 4D TES file
% 2008 Daniel M. Drucker ddrucker@psych.upenn.edu

ext = '.tes';
if ~strendswith(filename,ext),
    filename = [filename ext];
end
[dims,datatype,byteorder] = readvoxbohdr(filename);
if length(dims) ~= 4
    error('not a 4D file');
end
%try
    fid = fopen(filename);
    while 1
        tline = fgetl(fid);
        % look for the form feed
        if strcmp(tline,char(12)), break; end
    end
    % we should have passed the form-feed now
    % next now, read the mask
    mask = fread(fid,prod(dims(2:4)),'uint8');
    mask = logical(reshape(mask,dims(2:4)));

    % make it images-deep in the 4th dim
    mask = repmat(mask,[1 1 1 dims(1)]);
    mask = permute(mask,[4 1 2 3]);

    % now read the data
    rawdata = fread(fid,datatype,byteorder);
    tes=zeros(dims);
    tes(mask) = rawdata;
%catch
%    fclose(fid);
%    rethrow(lasterror);
%end
fclose(fid);

