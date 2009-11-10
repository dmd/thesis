function [mat,dims] = readmat(filename)
% [mat,dims] = readmat(filename)
% 2009 Daniel M. Drucker ddrucker@psych.upenn.edu

ext = '.mat';
if ~strendswith(filename,ext),
    filename = [filename ext];
end

[dims,datatype,byteorder] = readvoxbohdr(filename);

if length(dims) ~= 2
    error('not a 2D file');
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
    mat=reshape(rawdata,dims);
catch
    fclose(fid);
end
fclose(fid);
