
t=0;
par.numruns=5;
load dioct;
stims=GenerateBlobStimuli(dioct01);

for run=1:par.numruns
    par.order(:,run)=readref(sprintf('../../sequence/evaluator/dioct-seq-%d-optCE.txt',run));
end

mint = 10;
maxt = 40;
n=length(par.order)*par.numruns;
angles=floor(mint + (maxt-mint).*rand(n,1));
offsets=sign(rand(n,1)-.5);

stimnum=0;
for run=1:par.numruns
    stimnum=0;
    for stimid=par.order(:,run)'
        stimnum=stimnum+1
        s=stims.staticstimuli{stimid+1};
        if stimid == 0
            img=s;
        else
            img=drawslant(s,[size(s,1)/2 pointforslant(s,angles(stimnum),offsets(stimnum))],angles(stimnum),255);
        end
        imwrite(img,sprintf('images/%d-%d.png',run,stimnum));
    end
end
