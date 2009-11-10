function RTs = RunExperimentPreImages(par)
% stimulus display script - sequentially displays pregenerated images while tracking scanner TRs
% 2007-8 Daniel M. Drucker ddrucker@psych.upenn.edu
%
% 22 Oct 2007   dmd moved parameters to external runfile
% 29 Aug 2007   dmd stripped out flickering fixation, we're looking for
%               size change instead
% 27 Aug 2007   dmd updated to use new ODB blobs
% 12 Mar 2007   dmd wrote it

DEBUG              = par.DEBUG;
ramptime           = par.ramptime;
stimtime           = par.stimtime;
numruns            = par.numruns;
% initialize counters and such
sliptimebase            = 0.5;
trnum                   = 0;
missedtrnum             = 0;
graybg                  = [152 152 151]';
q=113; r=114; g=103; b=98; y=121; t=116; %#ok<NASGU> % useful ascii equivalences
Second_Of_Two_So_Check_For_T = false;

% load or generate the stimuli
FlushEvents;
WaitSecs(0); % preload this mex

Ts_To_Expect=par.nimages/2+1;

subject = subjectid(input('subject initials? ','s'));
filename = sprintf('%s_%s.txt',par.expname,subject);
fid = fopen(filename);
if fid ~= -1
    fclose(fid);
    disp 'warning, subject already exists ... C-c now or file will be overwritten';
    disp 'otherwise press enter to continue';
    pause;
end

fprintf('Expecting %d Ts, press enter to continue\n',Ts_To_Expect);
pause;

try
    window = SetUpTheScreen;
    blankframe = Screen('MakeTexture',window,imread([par.images 'blank.png']));
    Screen(window,'FillRect',graybg);
    Screen(window,'DrawText','please wait, loading...',0,0);
    Screen(window,'Flip');

    seq=0;
    RTs=[];
    for run=1:numruns
        
        Screen(window,'FillRect',graybg);
        DrawFormattedText(window, sprintf('run %d of %d ... waiting for first T',run,numruns), 'center', 'center', 0);
        Screen(window,'Flip');
        WaitForTWithTimeout(999);
        startruntime=GetSecs;
        for s = 1:par.nimages
            StartOfStim=GetSecs;
            FlushEvents;
            thisimage = imread([par.images num2str(run) '-' num2str(s) '.png']);
            thisframe = Screen('MakeTexture',window,thisimage);
            seq=seq+1;
            RTs(seq).run=run;
            RTs(seq).stim=s;

            beforeramp=GetSecs;
            if DEBUG; disp 'started ISI'; end;
            ISI(blankframe);
            if DEBUG; fprintf('ISI took %f\n',GetSecs-beforeramp); end;
            timeElapsed('done with ISI, starting stim');

            beforestim=GetSecs;

            ShowImgAndWaitAsync(thisframe);
            if DEBUG; fprintf('Stim shown for %f\n',GetSecs-beforestim); end;

            timeElapsed('done with stim');
            Second_Of_Two_So_Check_For_T = ~Second_Of_Two_So_Check_For_T;
            Screen('Close',thisframe);
        end


    end

    Screen(window,'FillRect',graybg);
    DrawFormattedText(window, 'all done, press t to exit', 'center', 'center', 0);
    Screen(window,'Flip');
    WaitForTWithTimeout(999);
    GiveBackTheScreen;
    WriteStructsToText(filename,RTs);

catch
    GiveBackTheScreen;
    WriteStructsToText(filename,RTs);
    rethrow(lasterror);
end

%%%% PRIVATE FUNCTIONS %%%%

    function timeElapsed(message)
        if DEBUG
            fprintf(strcat(message,sprintf(': %f',GetSecs-startruntime)));
            fprintf('\n');
        end
    end


    function ISI(frame)
        Screen('DrawTexture', window, frame);
        Screen('Flip',window);
        starttime=GetSecs;
        while GetSecs < (starttime + ramptime)

            %%% look for keyboard input...
            if CharAvail
                charreceived = GetChar(0,1);
                switch charreceived
                    case t
                        if Second_Of_Two_So_Check_For_T
                            fprintf('***** got a T (during ISI) when we weren''t expecting one, at %f ... out of sync.',GetSecs-startruntime);
                        end
                end
            end
            %%%
        end
    end

    function ShowImgAndWaitAsync(frame)
        gotAT=false;
        startStim = GetSecs;
        RTs(seq).correct = 0;
        if Second_Of_Two_So_Check_For_T   % if not checking for a T, don't waste time giving it benefit of doubt
            sliptime = sliptimebase;
        else
            sliptime = 0;
        end
        Screen('DrawTexture', window, frame);
        Screen(window,'Flip');
        while ((GetSecs - StartOfStim) < stimtime+sliptime)


            %%% look for keyboard input...
            if CharAvail
                charreceived = GetChar(0,1);
                switch charreceived
                    case t
                        if Second_Of_Two_So_Check_For_T
                            trnum = trnum + 1;
                            fprintf('got T %g (%g counting missed) at %f\n',trnum,trnum+missedtrnum,GetSecs-startruntime);
                            gotAT=true;
                            break;
                        else
                            fprintf('***** got a T (during odd-numbered stim) when we weren''t expecting one, at %f ... out of sync.',GetSecs-startruntime);
                        end
                    otherwise
                        DealWithQR(charreceived,startStim);
                end
            end
            %%%
            
            
            

            WaitSecs(0.0001);    % don't pound the cpu
        end
        if ~gotAT && Second_Of_Two_So_Check_For_T
            missedtrnum = missedtrnum + 1;
            fprintf('***** timed out... missed a T! at %f\n',GetSecs-startruntime);
        end

    end

    function DealWithQR(charreceived,startStim)
        RTs(seq).RT = GetSecs - startStim;
        if charreceived == 'q'
            error('experimenter terminated by pressing q');
        end
    end


end
