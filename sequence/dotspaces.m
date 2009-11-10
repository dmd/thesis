%% read the dioct
%load dioct;
%Coords = dioct01;
Coords = points(0,4)+2.5;

% functions we want to apply
funcs = [@nochange @linscaleify @squareify @invertedUify @sigmoidify @logify];
%funcs = [@nochange];

for pretransformaxes = [1 2]
    for pretransform = funcs

        % apply a transform to the Coords
        WarpCoords = Coords;
        WarpCoords(:,1) = pretransform(WarpCoords(:,1));
        if pretransformaxes == 2
            WarpCoords(:,2) = pretransform(WarpCoords(:,2));
        end

        figure;
        pointsfigure(WarpCoords,true);
        title([ func2str(pretransform) ' on ' num2str(pretransformaxes) ' axes']);
        print(gcf,'-deps', [ func2str(pretransform) num2str(pretransformaxes) ]);
        fprintf('%s\n',[ func2str(pretransform) num2str(pretransformaxes) ]);
        fprintf('%s\n',mat2str(WarpCoords));

    end
end
