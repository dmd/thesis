function voi2cub(pointsfile,cubsize,origin)
% VOI2CUB(POINTSFILE  [,SIZE [,ORIGIN]]])
%
% Reads a BrainVoyager VOI file, writes a set of VoxBo CUBs. 
% if SIZE is not specified, assume [256 256 256]
% if ORIGIN is not specified, assume [128 128 128]
%
% 2007 ddrucker@psych.upenn.edu


if nargin < 3
    origin = [128 128 128];
end
if nargin < 2
    cubsize = [256 256 256];
end

% read in the pointsfile, looking for NameOfVOI sections

voinum=0;
names={};
vois={};
fid = fopen(pointsfile);
while 1
    tline=fgetl(fid);
    if ~ischar(tline), break, end
    if strcmp(tline,''), continue, end %ignore blank lines
    if strfind(tline,'NameOfVOI')
        % new VOI stanza - get the name
        nv=split(tline,':  ');
        voinum=voinum+1;
        names{voinum}=nv{2};
    end
    if strfind(tline,'NrOfVoxels')
        numvoxels=split(tline,':  ');
        numvoxels=str2double(numvoxels{2});
        % read in this set of voxels
        vois{voinum} = cell2mat(textscan(fid,'%f %f %f\n',numvoxels));
    end
end
fclose(fid);

for i=1:voinum
    points = vois{i} + repmat(origin,length(vois{i}),1);
    cub = zeros(cubsize);
    cub(sub2ind(cubsize,points(:,1),points(:,2),points(:,3)))=1;
    writecub(names{i},cub,'mask');

    % now resample. these numbers may or may not work for you.
    % we're making some heavy assumptions here.

    system(['resample ' names{i} '.cub ' names{i} '.cub -nn -xx 49 1 159 -yy 16 1 189 -zz 77 1 138']);
    system(['resample ' names{i} '.cub ' names{i} '.cub  -nn -xx 2 3 53 -yy 2 3 63 -zz 2 3 46']);
end
