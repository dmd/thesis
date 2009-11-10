% set up the parameters

par.perms         = 1000              ;  % how many permutations to try?
par.TrialDuration = 1.5               ;  % length of stimulus in secs
par.HRFLength     = 16                ;  % length of convolving function in secs
par.ResolutionHz  = 10                ;  % resolution to convolve at in Hz
par.seqfile       = '../sequences17.txt' ;  % file generated by "seqgen -q" 
par.HRFFile       = 'highres.ref'     ;  % convolution function
par.HRFFileHz     = 10                ;  % resolution of convolving function file in Hz
par.BlankLength   = 2                 ;  % number of blanks to insert for each blank
par.numSeqs       = 100         ;  % number of best sequences we want
par.weneed=5;

%  Load the appropriate similarity spaces for which optimization will                     
%  be sought. each YOUR_SIMMAT should be a square symmetric matrix of
%  size [n n], where n is one less than the number of terms in the sequence
%  generated by seqgen.  diag(YOUR_SIMMAT1) should == 0.

% for now we're just going to load in Euclid and Tilt to play with
load dioct;
d = GenTestMat(dioct01);
SimMat(:,:,1)=ztransform_simmat(d.Euclid);
SimMat(:,:,2)=1;

%SimMat(:,:,1)=ztransform_simmat(d.City);
%SimMat(:,:,2)=ztransform_simmat(vec2sim(d.OrthoEuclidVec));


[alleffs, BestSeqs, bestEs, BestVec, BestFiltVec, allseqs] = EvaluateSeqs(par,SimMat);
