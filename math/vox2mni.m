function mnicoords = vox2mni(voxbocoords,origin,multiplier)
% mnicoords = vox2mni(voxbocoords,origin,multiplier)
% 
% Convert VoxBo to MNI coordinates
% default origin [26 37 17]
% default multiplier 3

if nargin < 2, origin = [26 37 17]; end
if nargin < 3, multiplier = 3; end

origin = repmat(origin,size(voxbocoords,1),1);

mnicoords = (voxbocoords - origin) .* multiplier;
mnicoords(1) = -mnicoords(1);
