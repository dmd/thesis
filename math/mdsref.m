function [reg,runs] = mdsref(nstims,nsplit)
% [reg,runs] = mdsref(nstims,nsplit)
% create a binref and runs for MVPA to read from a MDS_TrainingCubes-style PRM

reg=binref(ceil([1:nsplit*nstims]/nsplit));
runs=repmat(1:nsplit,1,nstims);
