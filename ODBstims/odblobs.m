%% define the space
%for kind={'balls' 'fetus' 'snm' 'cater' 'peanut'}
for kind={'test'}
    figure;
    stimtype='pointslist';
    load octagon;
    %pointslist=(octagon/(1+sqrt(2)/2))*(3/2)+2.5; % scale to be 1..4
    Ndim=4;
    pointslist=points(0,Ndim)+2.5;
    mysize=350;
    X=RFCcalc(ODBparams(kind{1}),mysize,stimtype,pointslist);

    % write to individual files
    for i=1:Ndim^2
        subplot(4,4,i);
        imagesc(~X{i});
        colormap gray; axis off; axis equal;
        %  imwrite(~X{i},sprintf('images/dioctODB-%02d.png',i));
    end
end
% %% make an octagon display
% octagon=octagon-min(min(octagon));
% octagon=octagon./max(max(octagon));
% octagon=octagon*(mysize*10-mysize)+1;
% canvas= zeros(mysize*10,mysize*10 );
% for i=1:Ndim^2
%     canvas(floor(octagon(i,1)):floor(octagon(i,1))+(mysize-1),floor(octagon(i,2)):floor(octagon(i,2))+(mysize-1) )=X{i};
% end
% imagesc(canvas);

