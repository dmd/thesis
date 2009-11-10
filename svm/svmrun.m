% This script is the complete automation of SVM.
% original version    2007 by Wesley Kerr and Daniel M. Drucker
% modified/cleaned up 2008 by Daniel M. Drucker ddrucker@psych.upenn.edu
% 
% April 2008 - using built in leave-one-out

if ~isvarname('expr'), error('This script must be run from a valid svmprep file which defines ''expr'', the experiment constants. See the source of this script for details.'); end

%{     
% This script must be called by a valid svmprep file which looks something like the following:

addpath('/ajet/ddrucker/experiments/matlablib','/usr/local/spm2');
expr.username         = 'ddrucker'                                           ;% VoxBo username, needed to wait for jobs
expr.subjects         = {'J122507C' 'D061207D'}                              ;% subject identifiers
expr.num_classes      = 16                                                   ;% number of classes
expr.num_exemplars    = 5                                                    ;% number of exemplars
expr.base_path        = '/ajet/ddrucker/experiments/SVMtest/TrainingCubes/'  ;% base folder of SVM directory; everything will happen under here
expr.roi_path         = '/ajet/ddrucker/blob1_data/ROIs/'                    ;% where ROIs masks are to be found. this may be left undefined (it will not be used) if you only specify 'whole' or 'backhalf' as an ROI.
expr.persubjectroi    = false                                                ;% should ROIs have SUBJECTID_ prepended to them?
expr.subjinit         = true                                                 ;% use initials instead of full subject id for ROIs?
expr.cleanup          = true                                                 ;% if false, we don't clean up at the end. default is true
expr.local            = false                                                ;% if true, do everything locally instead of using voxbo
%expr.rois={'V1' 'V2V3d' 'V2V3v' 'V4'};
expr.rois={'whole' 'backhalf'};

svmfast;
%}

svmlearncmd = '/ajet/ddrucker/experiments/matlablib/svm/svml/svm_learn_h2o -v 1 -x 1 ';

% Folder Conventions
runlabel                  = datestr(now,'yymmddHHMM')           ;% used to distinguish between different runs of the same script
paths.traincub_suffix     = '_TrainingCubes/'                   ;% where the cubs to train from will be found (suffix on subject)
paths.hyperplane          = ['work_' runlabel '/']              ;% where train/test/wei files will be saved
paths.wmap                = [expr.base_path 'wmaps/']           ;% where wmap cub files will be saved
paths.decision            = [expr.base_path 'decisions/']       ;% where decisions will be saved
paths.accuracy            = [expr.base_path 'accuracies/']      ;% where accuracies will be saved

% Cub File Conventions
paths.cub_prefix                       = 'MDS_'                 ;% cubs to train from start with this

% Train, Test, Model, Prediction Conventions
paths.train_prefix                     = 'train_'               ;
paths.model_prefix                     = 'predmodel_'           ;
paths.result_prefix                    = 'result_'              ;

% W-Map Files
paths.wmap_suffix                      = '_wmap'                ;
paths.wmap_average_file                = '_wmap_average_smooth' ;

% some calculated values
dimcub                                 = size(readcub([expr.base_path expr.subjects{1} paths.traincub_suffix paths.cub_prefix '1.1.cub']))      ;% dimensions of the cub file
numvoxels                              = prod(dimcub)                                                                                           ;% total number of voxels in the cub
numsubjects                            = length(expr.subjects)                                                                                  ;
numdecisions                           = expr.num_classes^2 - expr.num_classes                                                                  ;
ind                                    = [ones(1,expr.num_exemplars), -ones(1,expr.num_exemplars)]'                                             ;% indices for writing training/test files
if ~isfield(expr,'persubjectroi'), expr.persubjectroi = false; end                                                                              ;% are ROIs prefixed by subject id?
if ~isfield(expr,'subjinit'     ), expr.subjinit      = true ; end
if ~isfield(expr,'cleanup'      ), expr.cleanup       = true ; end                                                                              ;% remove the intermediate files?

%% Data preparation

% load all the cubes and write them out in SVMlight format
num_cubes_read = 0;
num_cubes_to_read = numsubjects * expr.num_classes * expr.num_exemplars;
p=progressbar();
for subject = 1:numsubjects
    for stim = 1:expr.num_classes
        for exm = 1:expr.num_exemplars
            num_cubes_read = num_cubes_read + 1;
            setStatus(p, num_cubes_read/num_cubes_to_read)
            fprintf('Reading %d of %d ...\n',num_cubes_read,num_cubes_to_read);
            cubs{subject,stim,exm} = readcub([expr.base_path expr.subjects{subject} paths.traincub_suffix paths.cub_prefix num2str(stim) '.' num2str(exm) '.cub']);
        end
    end
end

num_files_written = 0;
num_files_to_write = numdecisions / 2 * numsubjects * length(expr.rois);
p=progressbar();
for roi = 1:length(expr.rois)

    if ~expr.persubjectroi
        % mask should have nonzero values where you want to look
        switch expr.rois{roi}
            case 'whole'
                mask = ones(dimcub); % whole brain
            case 'backhalf'
                mask = ones(dimcub);
                mask(:,33:end,:) = 0; % back half of brain
            otherwise
                mask = readcub([expr.roi_path expr.rois{roi} '.cub']);
        end
        mask_indices = find(mask == 0);
    end
    
    for subject = 1:numsubjects
        if expr.persubjectroi
            if expr.subjinit
                subjid = subjinit(expr.subjects{subject});
            else
                subjid = expr.subjects{subject};
            end
            mask = readcub([expr.roi_path subjid '_' expr.rois{roi} '.cub']);
            mask_indices = find(mask == 0);
        end
        
        volpathdest = [expr.base_path expr.subjects{subject} paths.traincub_suffix paths.hyperplane];
        [success message messageid] = mkdir(volpathdest);
        
        for stimpair = nchoosek(1:expr.num_classes,2)'
            out = zeros(2*expr.num_exemplars,numvoxels);

            % vectorize the data cub file
            stimcount = 0;
            for stim = stimpair'
                for exm = 1:expr.num_exemplars
                    stimcount = stimcount + 1;
                    cubout = cubs{subject,stim,exm};
                    cubout(mask_indices) = 0;
                    out(stimcount,:) = cubout(:)';
                end
            end
            
            % write a training file for each pairwise decision
            trainfile = [volpathdest expr.rois{roi} paths.train_prefix expr.subjects{subject} '_' num2str(stimpair(1)) 'v' num2str(stimpair(2)) '.dat'];
            svmlwrite(trainfile, out, ind);
            num_files_written = num_files_written + 1;
            setStatus(p, num_files_written/num_files_to_write)
            fprintf('Writing %d of %d ...\n',num_files_written,num_files_to_write);
        end
    end
end


%% Model Creation in Voxbo - create the hyperplane.
p=progressbar();
num_jobs_added = 0;
num_jobs = num_files_to_write;
seqname = ['SVM' runlabel];
if ~expr.local
    system(['vbbatch -f ' seqname]);
end
for roi = 1:length(expr.rois)
    for subject = 1:numsubjects
        volpathdest = [expr.base_path expr.subjects{subject} paths.traincub_suffix paths.hyperplane];
        for stimpair = nchoosek(1:expr.num_classes,2)'
            trainfile  = [volpathdest expr.rois{roi} paths.train_prefix  expr.subjects{subject} '_' num2str(stimpair(1)) 'v' num2str(stimpair(2)) '.dat'];
            modelfile  = [volpathdest expr.rois{roi} paths.model_prefix  expr.subjects{subject} '_' num2str(stimpair(1)) 'v' num2str(stimpair(2)) '.dat'];
            resultfile = [volpathdest expr.rois{roi} paths.result_prefix expr.subjects{subject} '_' num2str(stimpair(1)) 'v' num2str(stimpair(2)) '.out'];
            if expr.local
                system([svmlearncmd ' ' trainfile ' ' modelfile ' | grep Leave | grep error | cut -f2 -d= > ' resultfile]);
            else
                system(['vbbatch -e -- -m 15 -p 2 -sn ' seqname ' -a ' seqname ' -c "' svmlearncmd ' ' trainfile ' ' modelfile ' | grep Leave | grep error | cut -f2 -d= > ' resultfile '" x > /dev/null']);
            end
            num_jobs_added = num_jobs_added + 1;
            setStatus(p, num_jobs_added/num_jobs)
            if expr.local
                fprintf('Running job %d of %d ...\n',num_jobs_added,num_jobs);              
            else
                fprintf('Submitting job %d of %d ...\n',num_jobs_added,num_jobs);
            end
        end
    end
end
if ~expr.local
    [status,seqnumber] = system(['vbbatch -e -- -s ' seqname ' |cut -c23-27']);
    seqnumber = str2num(seqnumber); %#ok<ST2NM>
    fprintf('Sequence number is %d.\n', seqnumber);
    % waiting for Voxbo to finish model creation
    status = -1;
    while status ~= 0
        [status,result] = system(['vq -s ' num2str(seqnumber)]);
        switch status
            case 1
                fprintf('Sequence running...\n');
            case 5
                fprintf('Waiting to run...\n');
            case {3,4}
                error('Sequence killed or gone bad, exiting.');
            case 6
                fprintf('Couldn''t get sequence status, still looking...\n');
        end
        pause(20);
    end
    fprintf('Sequence complete.\n');
end
%% W-Map Creation
% use the modelfile written by svm_learn to assess the w-value at
% each voxel; output a cub file of the same size as the original
% displaying these values.

[success message messageid] = mkdir(paths.wmap);

map = zeros(dimcub);
num_files_written = 0;
num_files_to_write = length(expr.rois)*numsubjects;
p = progressbar();
for roi = 1:length(expr.rois)
    for subject = 1:numsubjects

        out=zeros(numvoxels,1);

        volpathdest = [expr.base_path expr.subjects{subject} paths.traincub_suffix paths.hyperplane ];
        
        for stimpair = nchoosek(1:expr.num_classes,2)'
            weitoread = [volpathdest expr.rois{roi} paths.model_prefix expr.subjects{subject} '_' num2str(stimpair(1)) 'v' num2str(stimpair(2)) '.dat.wei'];
            image = svmlreadwei(weitoread,false);
            image(end+1:numvoxels) = 0; % svmlight truncates trailing zeros; we put them back so we can reshape it correctly
            out = out + image;
        end
        
        % create per-subject z-transformed w-map. note that we are constructing wmap
        % that is the AVERAGE of several z-transformed maps, and NOT z-transforming the AVERAGE map.
        % this means that a final w-value of N at some voxel corresponds to an AVERAGE z-score of N.
        wmapfile= [paths.wmap expr.rois{roi} '_' expr.subjects{subject} paths.wmap_suffix ];
        writecub(wmapfile,abs(ztransform(reshape(out,dimcub))));
        system(['vbsmooth -o ' wmapfile '_smoothed.cub ' wmapfile '.cub']);

        % For the cross-roi w-map, read in the smoothed map and add it to the total.
        map = map + readcub([wmapfile '_smoothed.cub']);
        num_files_written = num_files_written + 1;
        setStatus(p, num_files_written / num_files_to_write)
        fprintf('roi %d of %d / subject %d of %d ...\n', roi, length(expr.rois), subject, numsubjects);
    end

    map = ztransform(map);
    writecub([paths.wmap expr.rois{roi} paths.wmap_average_file],map);
end


%% get the leave-one-out percentages

[success message messageid] = mkdir(paths.decision);

for roi = 1:length(expr.rois)
    accuracy_roi = zeros(expr.num_classes);
    for subject = 1:numsubjects
        volpathdest = [expr.base_path expr.subjects{subject} paths.traincub_suffix paths.hyperplane ];
        accuracy_subject = zeros(expr.num_classes);
        for stimpair = nchoosek(1:expr.num_classes,2)'
            accuracy_subject(stimpair(1),stimpair(2)) = 100 - load([volpathdest expr.rois{roi} paths.result_prefix expr.subjects{subject} '_' num2str(stimpair(1)) 'v' num2str(stimpair(2)) '.out']);
        end
        csvwrite([paths.decision expr.rois{roi} '_' expr.subjects{subject} '_accuracy'], accuracy_subject);
        csvwrite([paths.decision expr.rois{roi} '_' expr.subjects{subject} '_accuracy_total'], mean(sim2vec(accuracy_subject')));
        accuracy_roi = accuracy_roi + accuracy_subject;
    end
    csvwrite([paths.decision expr.rois{roi} '_avg_accuracy'], accuracy_roi / numsubjects);
    csvwrite([paths.decision expr.rois{roi} '_avg_accuracy_total'], mean(sim2vec((accuracy_roi / numsubjects)')));
    
end
            

%% Cleaning Up
% This deletes all the testfile, trainfile, modelfile, and predfile but leaves the outputs.

if expr.cleanup
    fprintf('Cleaning up\n');
    for subject=1:numsubjects
        for exemplar=1:expr.num_exemplars
            system(['rm -rf ' expr.base_path expr.subjects{subject} paths.traincub_suffix paths.hyperplane]);
        end
    end
else
    fprintf('NOT cleaning up after myself.\n');
end
fprintf('DONE!\n');

