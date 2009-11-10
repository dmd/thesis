% read the dioct
load dioct;
Coords = dioct01;
seqs=dlmread('testseqs.txt');
% functions we want to apply
funcs = [@nochange @linscaleify @squareify  @sigmoidify @logify];
minkexponents=[1 2];
rotdegs = [0 22 45];
fid = fopen(['calcdistortoutput-allseqs-smallscale.txt'],'w');
fprintf(fid,'rot\tseq\tassumed\tpretransform\tpretransformed axes\tposttransform\tbeta P\tbeta Q\tbeta OE\n');
fprintf('rot\tseq\tassumed\tpretransform\tpretransformed axes\tposttransform\tbeta P\tbeta Q\tbeta OE\n');
% loop over sequences
progb=progressbar();
done=0;
todo=length(rotdegs)*size(seqs,2)*2*length(funcs)*length(funcs)*length(minkexponents);
% loop over rotations
for rotdeg=rotdegs
    for s=1:size(seqs,2)

        % create the HRF-convolved vectors to test against (this is the model)
        plain_covs = genccocovold(seqs(:,s),[],Coords,[],0);
        hrf_plain_adaptP = hrfconv(plain_covs.adaptP);
        hrf_plain_adaptQ = hrfconv(plain_covs.adaptQ);
        hrf_plain_oe     = hrfconv(plain_covs.adaptOrthoEuclid);

        for pretransformaxes = [1 2]
            for pretransform = funcs
                for posttransform = funcs
                    for minkexponent = minkexponents
                        done=done+1;
                        % apply a transform to the Coords
                        WarpCoords = Coords;
                        WarpCoords(:,1) = pretransform(WarpCoords(:,1));
                        if pretransformaxes == 2,
                            WarpCoords(:,2) = pretransform(WarpCoords(:,2));
                        end

                        % create the Warped vector to test against (this is the 'data')
                        warp_covs = genccocov(seqs(:,s),rotdeg,WarpCoords,[],0,minkexponent);

                        % warp from neural to fmri
                        % using the SMALLSCALE function to only use the
                        % most accelerating 20% of the function

                        warp_warp_adaptMink = applyssfunc(posttransform,(warp_covs.adaptMink));

                        
                        %warp_warp_adaptMink = posttransform(warp_covs.adaptMink);


                        % get the betas for adapt
                        G = zeros(length(hrf_plain_adaptP(1:10:end)),4);
                        G(:,1) = 1;
                        G(:,2) = hrf_plain_adaptP(1:10:end);
                        G(:,3) = hrf_plain_adaptQ(1:10:end);
                        G(:,4) = hrf_plain_oe(1:10:end);

                        hrf_warp_adaptMink = hrfconv(warp_warp_adaptMink); % MINK version

                        [BetasMink,ErrorSqMink,ResidualsMink] = getBetas(G,hrf_warp_adaptMink(1:10:end));

                        fprintf(fid,'%g\t%g\t%g\t%s\t%g\t%s\t%g\t%g\t%g\n',rotdeg,s,minkexponent,func2str(pretransform),pretransformaxes,func2str(posttransform),BetasMink(2),BetasMink(3),BetasMink(4));
                        %fprintf('%g\t%g\t%g\t%s\t%g\t%s\t%g\t%g\t%g\n',rotdeg,s,minkexponent,func2str(pretransform),pretransformaxes,func2str(posttransform),BetasMink(2),BetasMink(3),BetasMink(4));
                        setStatus(progb,done/todo)
                    end
                end
            end
        end
    end
end
fclose(fid);
