% svm-prep
%
% This prepares an SVM job for execution using svm-run.
addpath('/ajet/ddrucker/experiments/matlablib','/usr/local/spm2');

expr.username         = 'ddrucker'                                           ;% for VoxBo job completion checking
expr.subjects         = {'TEST'}                                             ;% subject identifiers
expr.num_classes      = 16                                                   ;% number of classes
expr.num_exemplars    = 5                                                    ;% number of exemplars
expr.base_path        = '/ajet/ddrucker/experiments/SVMtest/TrainingCubes/'  ;% base folder of SVM directory; everything will happen under here
expr.roi_path         = '/ajet/ddrucker/blob1_data/ROIs/'                    ;% where ROIs masks are to be found. this may be left undefined (it will not be used) if you only specify 'whole' as an ROI.
expr.persubjectroi    = false                                                ;% should ROIs have SUBJECTID_ prepended to them?
expr.local            = false                                                ;% if true, do everything locally instead of using voxbo


%expr.rois={'V1' 'V2V3d' 'V2V3v' 'V4'};
%expr.rois={'Adapt_RpFS_forDMD' 'Bilat_VentralLOC' 'wMap_LOC_forDMD' 'wMap_V3A_forDMD'};
expr.rois={'whole'};

svmrun;
