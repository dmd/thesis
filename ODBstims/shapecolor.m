%% define the space
stimtype='pointslist';
load octagon;
pointslist=(octagon/(1+sqrt(2)/2))*(3/2)+2.5; % scale to be 1..4
names=char(65:65+length(octagon)-1);
colors=pointslist(:,2);
pointslist(:,2)=mean(pointslist(:,2));
params;
step=	[0		7.5	0		0		7.5	0		0]; % was 6
mysize=512;
RFCcalc;

%% display
background = [0 0 0];
L = 64; a = 36; b = -38;
for i=1:length(pointslist)
    %figure(i);
    im=X{i};
    [R,G,B]=Lab2RGB(L,a,b+(colors(i)-1)*20);
    C{i}=imoverlay(fullcolorscreen(background'./255,size(im,1),size(im,2)),logical(im),[R G B]'./255);
%    subplot(4,4,i),image(C{i})
%    colormap gray; axis off; axis equal;
%    imwrite(C{i},sprintf('images/dioct-color-%s.png',names(i)));
end

%% display or save

load octagon;
octagon=octagon-min(min(octagon));
octagon=octagon./max(max(octagon));
octagon=octagon*(5120-512)+1;
canvas=uint8(zeros(mysize*10,mysize*10,3));
for i=1:length(pointslist)
    canvas(floor(octagon(i,1)):floor(octagon(i,1))+511,floor(octagon(i,2)):floor(octagon(i,2))+511,:)=C{i};
end
image(canvas);
