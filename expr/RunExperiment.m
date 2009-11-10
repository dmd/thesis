function RTs = RunExperiment(par)
% ColorExperiment
%
% 22 Oct 2007   dmd moved parameters to external runfile
% 29 Aug 2007   dmd stripped out flickering fixation, we're looking for
%               size change instead
% 27 Aug 2007   dmd updated to use new ODB blobs
% 12 Mar 2007   dmd wrote it

DEBUG              = par.DEBUG;
ramptime           = par.ramptime;
resizeratios       = par.resizeratios;
order              = par.order;
% KEYBOARD_DEVICE         = FindKeyboard;

% initialize counters and such
stimtime                = 1.5;
sliptimebase            = 0.5;
trnum                   = 0;
missedtrnum             = 0;
graybg                  = [152 152 151]';
q=113; r=114; g=103; b=98; y=121; t=116; %#ok<NASGU> % useful ascii equivalences
Second_Of_Two_So_Check_For_T = false;
lastSize                = 0;

global stims;
global fadeupmovies;
global grayscreen; %#ok<NUSED>
global staticstimuli;

% load or generate the stimuli
FlushEvents;
rand('state',sum(100*clock)); % init the random number generator. what century is this again that we have to do this!?
WaitSecs(0); % preload this mex

if DEBUG
    order=order(1:10,1);
end
order=order+1; % matlab indexes by 1

Ts_To_Expect=length(order)/2+1;

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

load(par.expname);

fadeupmovies  = stims.fadeupmovies;
grayscreen    = stims.grayscreen;
staticstimuli = stims.staticstimuli;

try
    window = SetUpTheScreen;
    Screen(window,'FillRect',graybg);
    Screen(window,'DrawText','please wait, loading...',0,0);
    Screen(window,'Flip');

    ifi=Screen('GetFlipInterval', window);

    % precompute! precompute! precompute!
    for color=1:length(staticstimuli);
        colortextures(color) = Screen('MakeTexture',window,staticstimuli{color});
        for ff=1:length(fadeupmovies{1})
            fadetextures(color,ff) = Screen('MakeTexture',window,fadeupmovies{color}(ff).cdata);
        end
        PreRamp(color);
    end
    seq=0;
    RTs=[];
    for run=1:size(order,2)
        
        Screen(window,'FillRect',graybg);
        DrawFormattedText(window, sprintf('run %d of %d ... waiting for first T',run,size(order,2)), 'center', 'center', 0);
        Screen(window,'Flip');
        WaitForTWithTimeout(999);

        % the instant the T is sent, we're at the H
        % now we begin the sequence
        %
        %                       | listening for T here
        % FFFFFFFFFFFFFF
        %      _______    _______
        %  \  /       \  /       
        % H \/    1    \/    2    

        startruntime=GetSecs;
        for s = 1:length(order)
            seq=seq+1;
            RTs(seq).run=run;
            RTs(seq).stim=s;
            
            StartOfStim=GetSecs;

            if s == 1
                WaitSecs(ramptime); % the very first time, there's nothing to ramp down from!
                timeElapsed('fake-ramp down for first time complete');
            else
                beforeramp=GetSecs;
                timeElapsed('starting ramp down');
                Ramp(lastEntry,'descend'); % ramp down
                if DEBUG; fprintf('Ramp down took %f\n',GetSecs-beforeramp); end;
                timeElapsed('finished ramp down');
            end

            id = order(s,run);
            prevSize=lastSize;
            [whichEntry,lastSize] = getEntry(id);
            if id == 1
                RTs(seq).color = 0;
                RTs(seq).shape = 0;
            else
                RTs(seq).color = floor((id-2)/4)+1;
                RTs(seq).shape = mod((id-2),4)+1;
            end

            beforeramp=GetSecs;
            if DEBUG; disp 'started ramp up'; end;
            Ramp(whichEntry);
            if DEBUG; fprintf('Ramp up took %f\n',GetSecs-beforeramp); end;
            timeElapsed('done with ramp up, starting stim');

            beforestim=GetSecs;

            ShowAndWaitAsync(whichEntry);
            if DEBUG; fprintf('Stim shown for %f\n',GetSecs-beforestim); end;

            timeElapsed('done with stim');
            lastEntry=whichEntry;
            Second_Of_Two_So_Check_For_T = ~Second_Of_Two_So_Check_For_T;
            FlushEvents;
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

    function [whichEntry,whichSize] = getEntry(id)
        if id == 1
            whichEntry = 1;
            whichSize = -1;
        else
            while 1 %emulate an UNTIL loop
                whichSize = floor(rand*length(resizeratios));
                if whichSize ~= lastSize; break; end; % we want to randomly choose a size that isn't the last size
            end
            whichEntry = (id-2)*length(resizeratios)+whichSize+2;
        end
    end

    function Ramp(color,direction)
        if nargin < 2
            direction = 'ascend';
        end
        for fff=sort(1:length(fadeupmovies{1}),direction)

            %%% look for keyboard input...
            if CharAvail
                charreceived = GetChar(0,1);
                switch charreceived
                    case t
                        if Second_Of_Two_So_Check_For_T
                            fprintf('***** got a T (during ramp) when we weren''t expecting one, at %f ... out of sync.',GetSecs-startruntime);
                        end
                end
            end
            %%%

            Screen('DrawTexture', window, fadetextures(color,fff));
             %           Screen('Flip', window);
            Screen('Flip', window,GetSecs+ifi); % flipping half as many times, for half as many fadeups, see GenerateBlobStimuli line 7

        end
    end

    function PreRamp(color)
        for fff=sort(1:length(fadeupmovies{1}),'ascend')
            Screen('DrawTexture', window, fadetextures(color,fff));
            DrawFormattedText(window, 'please wait, loading images', 'center', 'center', 0);
            Screen('Flip',window);
        end
    end

    function ShowAndWaitAsync(color)
        gotAT=false;
        startStim = GetSecs;
        RTs(seq).correct = 0;
        if Second_Of_Two_So_Check_For_T   % if not checking for a T, don't waste time giving it benefit of doubt
            sliptime = sliptimebase;
        else
            sliptime = 0;
        end
        Screen('DrawTexture', window, colortextures(color));
        Screen(window,'Flip');
        fprintf('this size is %d, previous size was %d\n',lastSize,prevSize);
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
            
            
            

            WaitSecs(0.001);    % don't pound the cpu
        end
        if ~gotAT && Second_Of_Two_So_Check_For_T
            missedtrnum = missedtrnum + 1;
            fprintf('***** timed out... missed a T! at %f\n',GetSecs-startruntime);
        end

    end

    function DealWithQR(charreceived,startStim)
        RTs(seq).RT = GetSecs - startStim;
        switch charreceived
            case q
                error('experimenter terminated by pressing q');
            case r % they said bigger
                if lastSize > prevSize
                    RTs(seq).correct = 1;
                end
            case g % they said smaller
                if prevSize > lastSize
                    RTs(seq).correct = 1;
                end
        end
    end


end
