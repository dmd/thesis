%function PlotMink(Coords)
% PlotMink(Coords,WarpCoords)
% makes a mink graph with the points Coords
% if Coords is not given, uses a plain grid

% set defaults
%if nargin < 1
% 4x4 square grid
clear
load outeroctagon;
Coords=octagon01;
%Coords=points(0,4)+1;
%end
minm = .5;
maxm = 222;
Coords=Coords./max(max(Coords));

%% create G matrix

WarpCoords = Coords;
% WARP!

%WarpCoords(:,1) = 4.*WarpCoords(:,1).*WarpCoords(:,1);
%WarpCoords(:,2) = 4.*WarpCoords(:,2).*WarpCoords(:,2);
%WarpCoords(:,2) = WarpCoords(:,2).*4;

WarpCoords=WarpCoords./max(max(WarpCoords));


%% compute betas
i=0;
mrange = linspace(minm,maxm,60);
rb = {'ErrorSq' 'CityPVec' 'CityQVec' 'OrthoEuclid' };
%rb = {'ErrorSq' 'CityPVec' 'CityQVec' 'CityPPVec' 'CityQQVec' 'OrthoEuclid' };

for m = mrange
    wcrot=0;
    DistsVec = mncn(getalldistances(WarpCoords,wcrot,m));
    i=i+1;        % i,j = results indices
    fprintf('%d%% ',floor((m-min(mrange))/(max(mrange)-min(mrange))*100));

    % set up our G matrix

    d=GenTestMat(Coords);                  gg=0;
    G=zeros(d.OrderG,3);                   gg=gg+1;
    G(:,gg)=1;                              gg=gg+1;% intercept 
    G(:,gg)=d.CityPVec;                     gg=gg+1;
    G(:,gg)=d.CityQVec;                     gg=gg+1;
%    G(:,gg)=orthogonalize(G,d.CityPVec.^2); gg=gg+1;
%    G(:,gg)=orthogonalize(G,d.CityQVec.^2); gg=gg+1;
    G(:,gg)=orthogonalize(G,d.EuclidVec);   gg=gg+1;

    % compute the betas
    [Betas,ErrorSq,Residuals] = getBetas(G,DistsVec); %#ok<NASGU>

    % save the results for this min and tilt
    b=2;
    for r=rb
        if strcmp('ErrorSq',r{1})
            ResultsBeta.(r{1})(i) = ErrorSq;
        else
            ResultsBeta.(r{1})(i) = Betas(b);
            b=b+1;
        end
    end
end

mr = length(mrange);

%% plot the betas
plotnum=1;
for r=rb
    subplot(3,3,plotnum)
    plot(mrange,ResultsBeta.(r{1}));
    title(['values for ' r{1}]);

    xlabel('minkowski power');
    axis square;
    xlim([min(mrange) max(mrange)]);
    plotnum=plotnum+1;
end
subplot(3,3,plotnum)
pointsfigure(rotm(WarpCoords,wcrot),false);
axis equal;
fprintf('\n');