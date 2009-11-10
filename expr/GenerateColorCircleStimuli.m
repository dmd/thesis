function stims = GenerateColorCircleStimuli
% STIMS = GENERATECOLORCIRCLESTIMULI
%
% 2007 ddrucker@psych.upenn.edu

ramptime     = .125;
resizeratios = [.9 1 1.1];
bgcolor      = [152 152 151]';

radius       = 125;
border       = 50;
slop         = 10;
oct          = octcolors(42,29)'; % uh oh
colors       = floor(oct.*255);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% shouldn't have to modify below here
width = (radius*max(resizeratios)+border)*2+slop;
height = width;
numframes = round((ramptime)/60^-1);
numframes=numframes/2; % let's give the old processor a break, but we must remember to wait two frames when we display each

grayscreen = uint8(fullcolorscreen(bgcolor,height,width));

fadeupmovies = cell(1);
staticstimuli = cell(1);

ndex=1;
for targetcolor = colors
    for resizeratio=resizeratios
        ndex=ndex+1;
        circframe = centercolorcircle(targetcolor,bgcolor,radius*resizeratio,border,width,height);
        staticstimuli(ndex) = {circframe};

        framenum = 0;
        clear movi;
        for n = 1:numframes
            framenum = framenum+1;
            movi(framenum) = im2frame(fadetwoframes(grayscreen,circframe,n/numframes,@gaussmapper));
        end
        fadeupmovies(ndex) = {movi};
    end
end
clear movi;
staticstimuli(1) = {grayscreen};
for n=1:numframes
    movi(n) = im2frame(grayscreen);
end
fadeupmovies(1) = {movi};


stims.fadeupmovies  = fadeupmovies;
stims.grayscreen    = grayscreen;
stims.staticstimuli = staticstimuli;

end
