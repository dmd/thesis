function [R,NeuralCorrelationsVec] = CalcSimSpace(par,ObjSpace,mask,threshmask)
% R = CalcSimSpace(par,ObjSpace,mask)
% Compute the correlation between neural MDS volume correlations and
% perceptual correlation.
% par.numvox = number of highest-scoring voxels to use from mask
% par.nvolumes = number of MDS cubes to look for in MDSStem
% par.MDSStem = beginning of path to MDS cubes
% par.MDSSuffix = anything that comes after the MDS number including the
% filetype. cell array. may specify multiple.
% threshmask = if false, don't run highestincub. default TRUE
% 
% ObjSpace = par.nvolumes similarity matrix in sim2vec form (lower triangle vectorized) 
% mask = 3D map cube
%
% 2007 ddrucker@psych.upenn.edu

% operating with a mask?
havemask = nargin >= 3;
if nargin < 4
    threshmask = true;
end

%% take the highest NumVox values from the mask

if (havemask && threshmask)
    mask=highestincub(mask,par.numvox);
end

if havemask
    mask=logical(mask);
end

%% read (masked) cubs into VolumeBetas
if havemask
    VolumeBetas = zeros(par.nvolumes,total(mask)); % volumes x number of voxels above thresh
else
    % hack to get size
    vol = strcat(par.MDSStem, num2str(1), par.MDSSuffix{1});
    BetaCub = readcub(vol);
    VolumeBetas = zeros(par.nvolumes,numel(BetaCub));
end

% VolumeBetas has one row per volume, containing all the voxels in the mask for
% that volume. the inner loop is rarely used, it's if we want to sum
% multiple cubs for each volume.
for v=1:par.nvolumes
    for suf=par.MDSSuffix
        vol = strcat(par.MDSStem, num2str(v), suf);
        BetaCub = readcub(vol{1});
        if havemask
            VolumeBetas(v,:)=VolumeBetas(v,:)+BetaCub(mask)';
        else
            VolumeBetas(v,:)=VolumeBetas(v,:)+BetaCub(:)';
        end
    end
end
VolumeBetas=VolumeBetas./length(par.MDSSuffix); % if using multiple cubs, avg

%% 
VolumeBetas = VolumeBetas-repmat(mean(VolumeBetas),size(VolumeBetas,1),1);  % mean center

% create the NEURAL similarity matrix. NeuralCorrelations is nvolumes^2, where each
% cell is the correlation between the neural patterns of two volumes
NeuralCorrelations = zeros(par.nvolumes);
for x=1:par.nvolumes
    for y=1:par.nvolumes
        c=corrcoef(VolumeBetas(x,:),VolumeBetas(y,:));
        NeuralCorrelations(x,y)=c(1,2);
    end
end
NeuralCorrelationsVec=sim2vec(NeuralCorrelations);
c=corrcoef(NeuralCorrelationsVec,ObjSpace);
R=c(1,2);

