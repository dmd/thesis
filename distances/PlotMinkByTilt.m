%function PlotMinkByTilt(Coords)
% PlotMinkByTilt(Coords,WarpCoords)
% makes a minkbytilt graph with the points Coords
% if Coords is not given, uses a plain grid
clear ResultsBeta;
% set defaults
%if nargin < 1
% 4x4 square grid
load dioct;
Coords=dioct01;
%Coords=points(0,4)+1;
%end
minm = 1;
maxm = 200000;
Coords=Coords./max(max(Coords));

%% create G matrix

WarpCoords = Coords;
% WARP!

%WarpCoords(:,1) = WarpCoords(:,1).*WarpCoords(:,1);
%WarpCoords(:,2) = WarpCoords(:,2).*WarpCoords(:,2);
%WarpCoords(:,2) = WarpCoords(:,2).*1;

WarpCoords=WarpCoords./max(max(WarpCoords));


%% compute betas
degrange=linspace(0,45,100);
i=0;
mrange = [0.5 1 1.5 2 ]; %linspace(minm,maxm,21);
rb = {'ErrorSq' 'CityPVec' 'CityQVec' 'OrthoEuclid' };
%rb = {'ErrorSq' 'CityPVec' 'CityQVec' 'CityPPVec' 'CityQQVec' 'OrthoEuclid' };
for m = mrange

    i=i+1;        % i,j = results indices
    j=0;          %
    fprintf('%d%% ',floor((m-min(mrange))/(max(mrange)-min(mrange))*100));
    for t = degrange
        wcrot=22.5;
        DistsVec = mncn(getalldistances(WarpCoords,wcrot,m));
        j=j+1;

        % set up our G matrix

        d=GenTestMat(Coords,t);                  gg=0;
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
                ResultsBeta.(r{1})(i,j) = ErrorSq;
            else
                ResultsBeta.(r{1})(i,j) = Betas(b);
                b=b+1;
            end
        end

    end
end

dr = length(degrange);
mr = length(mrange);

%% plot the betas
plotnum=1;
for r=rb
    subplot(3,3,plotnum)
    mstep = range(ResultsBeta.(r{1})(:))/10;
    [C,h]=contour(degrange,mrange,ResultsBeta.(r{1}));
    set(h,'LevelStep',mstep,'ShowText','on','Fill','off','LineWidth',2);
    set(h,'TextStep',get(h,'LevelStep'));
    title(['values for ' r{1}]);

    bdiff = [abs(ResultsBeta.(r{1})(1,1)-ResultsBeta.(r{1})(1,dr)) abs(ResultsBeta.(r{1})(mr,1)-ResultsBeta.(r{1})(mr,dr))];
    bdiff(bdiff<0.0001)=0;

    xlabel({'degrees rotated'; ...
        ['values at ' num2str(max(mrange)) ' range ' num2str(ResultsBeta.(r{1})(mr,1),2)  ' to '  num2str(ResultsBeta.(r{1})(mr,dr),2)  ' diff of ' num2str(bdiff(2),2)]  ; ...
        ['values at ' num2str(min(mrange)) ' range ' num2str(ResultsBeta.(r{1})(1,1),2)   ' to '  num2str(ResultsBeta.(r{1})(1,dr),2)   ' diff of ' num2str(bdiff(1),2)]     ...
        });
    ylabel('minkowski power');
    axis square;
    ylim([min(mrange) max(mrange)]);xlim([0 max(degrange)]);
    colormap(jet);
    colorbar;
    plotnum=plotnum+1;
end
subplot(3,3,plotnum)
pointsfigure(rotm(WarpCoords,wcrot),false);
axis equal;
fprintf('\n');
