load effs_17t1_cityortho
X1=alleffs(1,:); Y1=alleffs(2,:);


% Create figure
figure1 = figure('XVisual',...
    '0x23 (TrueColor, depth 24, RGB mask 0xff0000 0xff00 0x00ff)');

% Create axes
axes('Parent',figure1,'YTick',[0 0.1 0.2 0.3 0.4 0.5],...
    'XTick',[0 0.1 0.2 0.3 0.4 0.5],...
    'PlotBoxAspectRatio',[1 1 1]);
% Uncomment the following line to preserve the X-limits of the axes
xlim([0 0.5]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim([0 0.5]);
box('on');
hold('all');

% Create plot
plot(X1,Y1,'Marker','.','LineStyle','none','Color',[0 0 0]);

% Create xlabel
xlabel({'city-block efficiency'});

% Create ylabel
ylabel({'orthoeuclid efficiency'});

% Create title
title({'Efficiencies of 17 element T1I1 sequences'});

