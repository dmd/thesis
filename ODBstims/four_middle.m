%% define the space

% create four stimuli which occupy the middle (non-existant) row of an
% octagon space and are spaced equally (also non-existant) as if they were
% in a grid configuration.
% we want the four stimuli at X = 1,2,3,4 and Y = 2.5
clear
stimtype='pointslist';
pointslist=[1 2.5; 2 2.5; 3 2.5; 4 2.5];
pointslist=[pointslist; pointslist; pointslist; pointslist];
mysize=320;
X=RFCcalc(ODBparams,mysize,stimtype,pointslist);
blank = zeros(325);
fixedRect = [0 0 size(blank)];
myRect = [1 1 mysize mysize];
centRect = CenterRect(myRect,fixedRect);

%% write to individual files
for i=1:4
    figure(i);
    Y{i} = blank;
    Y{i}(centRect(1):centRect(3),centRect(2):centRect(4)) = X{i};
    imagesc(Y{i});
    colormap gray; axis off; axis image;
%    imwrite(Y{i},sprintf('../../behnorm/midline-%d-%d.png',mysize,i));
end