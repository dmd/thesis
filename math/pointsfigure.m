function pointsfigure(pointslist,textlabels)
% pointsfigure(pointslist,textlabels)
% pointslist should be a size=[n 2] list of x y coords to be plotted
% textlabels, if true, makes the labels have letters next to them
%
% 2007 ddrucker@psych.upenn.edu

%names=cellstr(char(65:65+length(pointslist)-1)');
names=cellstr(num2str([1:length(pointslist)]'));

if nargin < 1
    % 4x4 square grid
    pointslist=([1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4;1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4]');
end

if nargin < 2
    textlabels = true;
end

plot(pointslist(:,1),pointslist(:,2),'.k');

if textlabels
    text(pointslist(:,1)+.03,pointslist(:,2),names,'Color','black','FontSize',20);
end
axis off;
axis equal;
