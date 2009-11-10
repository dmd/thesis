function refwithids = refsplit(ref,n,filename)
% REFWITHIDS = REFSPLIT(REF,N,filename)
% Randomly divides up the stims in a ref among N different exemplars. 
% saves to FILENAME (default MDS_Training)
% 2007 ddrucker@psych.upenn.edu

if nargin<3
    filename='MDS_Training';
end

stims=max(ref);
len=length(ref);
perm=repmat(1:n,1,length(find(ref==1))/n);


% at each point in the ref, for each stim, a choice of which cube we'll be throwing to

permchoices=zeros(length(perm),stims);
for i=1:stims
    permchoices(:,i) = perm(randperm(length(perm)));
end


stimcnt=zeros(stims,1);
refwithids = [];
for i=1:len
    if ref(i) == 0
        refwithids = [refwithids;0 0];
    else
        stimcnt(ref(i))=stimcnt(ref(i))+1;
        refwithids = [refwithids; ref(i) permchoices(stimcnt(ref(i)),ref(i))];
    end
end


fid=fopen([filename '.ref'],'w');
fprintf(fid,';VB98\n;REF1\n');
for pair=refwithids'
    if pair(1) == 0
        fprintf(fid,'Blank\n');
    else
        fprintf(fid,'Stim%02d_%02d\n',pair(1),pair(2));
    end
end
fclose(fid);
