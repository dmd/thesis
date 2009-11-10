function [subj results] = mvpasim(tesfilename,varargin)


defaults.stims = 16;
defaults.runs = 5;
defaults.space = [];
defaults.mask = 'backhalf';
args = propval(varargin,defaults);


if strcmp(args.space,'dioct')
    args.space = [0.292 0;0.707 0;1 0.292;1 0.707;0.707 1;0.292 1;0 0.707;0 0.292;0.292 0.292;0.5 0.207;0.707 0.292;0.792 0.5;0.707 0.707;0.5 0.792;0.292 0.707;0.207 0.5];
end



subj = init_subj(tesfilename,tesfilename);
subj = load_voxbo_mask(subj,args.mask,args.mask);
subj = load_voxbo_pattern(subj,'epi',args.mask,tesfilename);
[regs,runs] = mdsref(args.stims,args.runs);
subj = init_object(subj,'regressors','conds');
subj = set_mat(subj,'regressors','conds',regs);
subj = init_object(subj,'selector','runs');
subj = set_mat(subj,'selector','runs',runs);
subj = zscore_runs(subj,'epi','runs','ignore_jumbled_runs',true);
subj = create_xvalid_indices(subj,'runs','ignore_jumbled_runs',true);
subj = feature_select(subj,'epi_z','conds','runs_xval');
class_args.train_funct_name = 'train_ridge';
class_args.test_funct_name = 'test_ridge';
class_args.penalty=100;
perfmet_args.space = args.space;
if ~isempty(args.space)
    [subj results] = cross_validation(subj,'epi_z','conds','runs_xval','epi_z_thresh0.05',class_args, ...
'perfmet_functs',{'perfmet_distance'},'perfmet_args',perfmet_args);
else
    [subj results] = cross_validation(subj,'epi_z','conds','runs_xval','epi_z_thresh0.05',class_args);
end
