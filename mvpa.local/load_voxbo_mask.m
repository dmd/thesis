function [subj] = load_voxbo_mask(subj,new_maskname,filename)

% Loads a VOXBO dataset into the subj structure as a mask
%
% [SUBJ] = LOAD_VOXBO_MASK(SUBJ,NEW_MASKNAME,FILENAME)
%
% Adds the following objects:
% - mask object called NEW_MASKNAME
%
% ddrucker@psych.upenn.edu 2008 based on load_afni mask

% Initialize the new mask
subj = init_object(subj,'mask',new_maskname);

V = readcub([filename '.cub']);

if ~length(find(V))
  error( sprintf('There were no voxels active in the %s mask',filename) );
end

% Does this consist of solely ones and zeros?
if length(find(V)) ~= (length(find(V==0))+length(find(V==1)))
  disp( sprintf('Setting all non-zero values in the %s mask to one',filename) );
  V(find(V)) = 1;
end

% Store the data in the new mask structure
subj = set_mat(subj,'mask',new_maskname,V);

% Add the AFNI header to the patterns
hist_str = sprintf('Mask ''%s'' created by load_voxbo_mask',new_maskname);
subj = add_history(subj,'mask',new_maskname,hist_str,true);

% Add information to the new mask's header, for future reference
subj = set_objsubfield(subj,'mask',new_maskname,'header', ...
			 'afni_filename',filename,'ignore_absence',true);

% Record how this mask was created
created.function = 'load_voxbo_mask';
subj = add_created(subj,'mask',new_maskname,created);

