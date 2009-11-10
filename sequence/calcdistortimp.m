% read the dioct
load dioct;
Coords = dioct01;
seq = readref('sequence.ref');

% functions we want to apply
funcs = [@nochange @linscaleify @squareify @invertedUify @sigmoidify @logify];
%funcs = [@nochange];

% get the unique distances
plain_covs = genccocovold(seq,[],Coords,[],0);
plain_adapt = rounddig(plain_covs.adaptorig,3);  % fix rounding weirdness
uniquedists = unique(plain_adapt);
imps=zeros(length(uniquedists)-1,length(seq)); % -1 because we don't care about 0s
hrfimps=zeros(length(uniquedists)-1,15*length(seq)); 


% create the HRF-convolved vectors to test against (this is the model)
for i=2:length(uniquedists)
    imps(i-1,:) = plain_adapt==uniquedists(i);
    hrf_imps(i-1,:) = hrfconv(mncn(imps(i-1,:))');
end





fid = fopen('calcdistortoutput-impulse.txt','w');
fprintf(fid,'assumed\tpretransform\tpretransformed axes\tposttransform\t');
fprintf(fid,'b %g\t',uniquedists(2:end));
fprintf(fid,'\n');
for pretransformaxes = [1 2]
    for pretransform = funcs
        for posttransform = funcs
            for minkexponent = [0.1:0.1:3 50] %

                % apply a transform to the Coords
                WarpCoords = Coords;
                WarpCoords(:,1) = pretransform(WarpCoords(:,1));
                if pretransformaxes == 2,
                    WarpCoords(:,2) = pretransform(WarpCoords(:,2));
                end

                % create the Warped vector to test against (this is the 'data')
                warp_covs = genccocov(seq,[],WarpCoords,[],0,minkexponent);

                % warp from neural to fmri
                warp_warp_adaptMink = posttransform(warp_covs.adaptMink);

                % get the betas for adapt
                G = zeros(length(hrf_imps(:,1:10:end)),length(uniquedists));
                G(:,1) = 1;
                G(:,2:length(uniquedists)) = hrf_imps(:,1:10:end)';

                hrf_warp_adaptMink = hrfconv(warp_warp_adaptMink); % MINK version

                [BetasMink,ErrorSqMink,ResidualsMink] = getBetas(G,hrf_warp_adaptMink(1:10:end));

                fprintf(fid,'%g\t%s\t%g\t%s\t',minkexponent,func2str(pretransform),pretransformaxes,func2str(posttransform));
                fprintf(fid,'%g\t',BetasMink(2:end));
                fprintf(fid,'\n');
            end
        end
    end
end
fclose(fid);
