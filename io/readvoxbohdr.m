function [dims,datatype,byteorder] = readvoxbohdr(filename)
% [dims,datatype,byteorder] = readvoxbohdr(filename)
% helper function for readtes and readcub
% 2008 Daniel M. Drucker ddrucker@psych.upenn.edu

try
    fid = fopen(filename);
    byteorder = 'ieee-be'; % default if not specified
    dims = 0;

    while 1
        tline = fgetl(fid);

        % look for the form feed
        if strcmp(tline,char(12)), break; end
        % skip non-key/value lines
        if isequal(strfind(tline,':'),[]), continue; end
        tokline = split(tline,': 	');
        key = lower(tokline{1});
        value = tokline(2:end);

        if strfind(key,'voxdims')
            dims=cellfun(@str2num,value);
        end
        if strfind(key,'datatype')
            datatype=lower(value);
        end
        if strfind(key,'byteorder')
            if strcmp(value,'msbfirst')
                byteorder = 'ieee-be';
            elseif strcmp(value,'lsbfirst')
                byteorder = 'ieee-le';
            else
                error('did not understand byte order');
            end
        end
    end
    switch datatype{1}
        case 'integer'
            datatype='int16';
        case 'long'
            datatype='int32';
        case 'byte'
            datatype='uint8';
        case 'double'
            datatype='double';
        case 'float'
            datatype='float32';
        otherwise
            datatype='';
    end
    if dims == 0
        error('never got dimensions');
    end
    if strcmp(datatype,'')
        error('never got a valid datatype');
    end

catch
    fclose(fid);
end
fclose(fid);
