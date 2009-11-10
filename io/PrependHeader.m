function PrependHeader(filename,header)
% PrependHeader(filename,header)
% 
% prepends the string 'header' to the file 'filename'
%
% 2007 ddrucker@psych.upenn.edu

% should we do this matlab-way? i'm just going to do it in the shell for
% simplicity's sake

try
    system(['cp ' filename ' ' filename '.tmp_PrependHeader']);
    fid=fopen(filename,'w');
    fprintf(fid,header);
    fclose(fid);
    system(['cat ' filename '.tmp_PrependHeader >> ' filename]);
catch
    system(['cp ' filename '.tmp_PrependHeader ' filename]);
    disp 'Something went wrong, trying to abort by copying back.';
end
system(['rm ' filename '.tmp_PrependHeader']);
