function stims = GenerateBlobStimuli(pointslist)
% STIMS = GENERATEBLOBSTIMULI
%
% 2008-04-17 blobs vs blobs
% 2007-11-08 just one size
% 2007 ddrucker@psych.upenn.edu

ramptime     = .08;
resizeratios = 1;
width        = 640;
height       = 480;
bgcolor      = [152 152 151]';

% specify the ENTIRE list of points in shape-space

pointslist=pointslist*4;

%basecolor = [40 40 190]; % in LCH
%
%lchcolors = zeros(length(pointslist),3);
%for i=1:length(pointslist)
%    lchcolors(i,:)=basecolor - [0 0 20*dioct(i,2)];
%end

color = lab2srgb((lch2lab([40 40 170])));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% shouldn't have to modify below here

numframes = round((ramptime)/60^-1);
numframes=numframes/2; % let's give the old processor a break, but we must remember to wait two frames when we display each

grayscreen = uint8(fullcolorscreen(bgcolor,height,width));
fadeupmovies  = cell(1);
staticstimuli = cell(1);

cbnum=1;
for blobnum=1:length(pointslist)
    blobmask = GenerateBlobMask(pointslist(blobnum,:));
    for resizeratio=1:length(resizeratios)
        cbnum = cbnum+1;
        thisgrayscreen = grayscreen(1:size(blobmask{resizeratio},1),1:size(blobmask{resizeratio},2),:);
        staticstimuli(cbnum) = {imoverlay(thisgrayscreen,blobmask{resizeratio},color)};
        framenum = 0;
        clear movi;
        for n = 1:numframes
            framenum = framenum+1;
            movi(n) = im2frame(fadetwoframes(thisgrayscreen,staticstimuli{cbnum},n/numframes,@gaussmapper));
        end
        fadeupmovies(cbnum) = {movi};
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


    function blobmask = GenerateBlobMask(point)
        ndex=0;
        blobmask = cell(1);
        stimtype='pointslist';
        mysize=640;
        X=RFCcalc(ODBparams,mysize,stimtype,point);
        X{1}=cropbwimage(im2bw(X{1}));
        %  winsize=ceil(max(size(X{1}))*max(resizeratios)+10); winsize =   [winsize winsize]
        winsize = [480 640];
        for resizeratio = resizeratios
            ndex=ndex+1;
            blobmask(ndex) = {logical(CenterInBlack(imresize(X{1},resizeratio),winsize))};
        end
        close all;
    end

end
