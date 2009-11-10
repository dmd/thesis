function [cub,dims] = readcub(filename)
% [cub,dims] = readcub(filename)
% 2008 Daniel M. Drucker ddrucker@psych.upenn.edu

ext = '.cub';
if ~strendswith(filename,ext),
    filename = [filename ext];
end
[dims,datatype,byteorder] = readvoxbohdr(filename);

if length(dims) ~= 3
    error('not a 3D file');
end
try
    fid = fopen(filename);
    while 1
        tline = fgetl(fid);
        % look for the form feed
        if strcmp(tline,char(12)), break; end
    end
    % we should have passed the form-feed now
    % now read the data
    rawdata = fread(fid,datatype,byteorder);
    cub=reshape(rawdata,dims);
catch
    fclose(fid);
end
fclose(fid);
