function writeccocov(varargin)
% WRITECCOCOV(DEGREES,POINTSLIST,USETARGET,CUTOFFFIRST,RUNFILES,SEQUENCE, MINKEXPONENT)
% Generates covariates CCO design given a set of points and a degrees of assumed axis rotation. 
% sequence is a list of stimulus ids, including the first CUTOFFFIRST which will be discarded
% DEGREES         default = no rotation (0 deg)
% POINTSLIST      default = 4x4 linearly scaled grid
% USETARGET       default = no target
% CUTOFFFIRST     default = 10
% SEQUENCE        if specified, use this sequence instead of reading 
%
% reads sequence file, calls genccocov to generate the covs, writes ref files
% 2007 ddrucker@psych.upenn.edu

defaultValues={0,points(0,4),false,10,5,[],2};
nonemptyIdx = ~cellfun('isempty',varargin);
defaultValues(nonemptyIdx) = varargin(nonemptyIdx);
[degrees pointslist usetarget cutofffirst runfiles sequence minkexponent] = deal(defaultValues{:});
useseq = isempty(sequence);
for i=1:runfiles
    if useseq
        sequence = readref(['dioct-seq-' num2str(i) '-optCE.txt']);
%        sequence = readref(['dioct18-target-' num2str(i) '-optCE.txt']);
%        sequence = readref(['out' num2str(i) '.txt']);
    end
    c(i) = genccocov(sequence,degrees,pointslist,usetarget,cutofffirst, minkexponent);
end


writeref('main.ref',            cat(1, c(:).main        ));
writeref('new.ref',             cat(1, c(:).new         ));
writeref('rept.ref',            cat(1, c(:).rept        ));
writeref('directP.ref',         cat(1, c(:).directP     ));
writeref('directQ.ref',         cat(1, c(:).directQ     ));
writeref('adaptorig.ref',       cat(1, c(:).adaptorig    ));
% the following is unix-dependent. I'd really like to do this a more portable way, but Matlab, strings, and I don't get along.
!sed -i -e 's/-9/new/' adaptorig.ref
!sed -i -e 's/-5/rept/' adaptorig.ref
delete adaptorig.ref-e  % this is retarded I know; it's a osx vs linux sed difference bug thing.
writeref('adapteuorig.ref',     cat(1, c(:).adapteuorig  ));
!sed -i -e 's/-9/new/' adapteuorig.ref
!sed -i -e 's/-5/rept/' adapteuorig.ref
delete adapteuorig.ref-e
%writeref('adaptN.ref',          cat(1, c(:).adaptN       ));
%writeref('adaptNP.ref',         cat(1, c(:).adaptNP      ));
%writeref('adaptNQ.ref',         cat(1, c(:).adaptNQ      ));
writeref('adaptP.ref',          rangeone(cat(1, c(:).adaptP      )));
writeref('adaptQ.ref',          rangeone(cat(1, c(:).adaptQ      )));
writeref('adapteu.ref',         rangeone(cat(1, c(:).adapteu     )));
writeref('adapt.ref',           rangeone(cat(1, c(:).adapt       )));
writeref('adaptOrthoEuclid.ref', rangeone(cat(1,c(:).adaptOrthoEuclid)));

dlmwrite('sequence.ref',cat(1,c(:).sequence),'precision','%02d');
PrependHeader('sequence.ref',';VB98\n;REF1\n');

fid=fopen('pairings.ref','w');
for r=1:runfiles
    for i=1:length(cat(1,c(r).apd))
        fprintf(fid,'%s\n',cat(1,c(r).apd{i}));
    end
end
fclose(fid);
PrependHeader('pairings.ref',';VB98\n;REF\n');

fid=fopen('saulpairings.ref','w');
for r=1:runfiles
    for i=1:length(cat(1,c(r).apd))
        fprintf(fid,'%s\n',cat(1,c(r).saulapd{i}));
    end
end
fclose(fid);
PrependHeader('saulpairings.ref',';VB98\n;REF\n');

if usetarget  % alison wants these, i don't
    writeref('target.ref',      cat(1, c(:).target      ));
    writeref('aftertarget.ref', cat(1, c(:).aftertarget ));
    i=0;
    ddists = cat(1,c(:).ddists);
%    for angle=c(1).anglelist'
%        i=i+1;
%        writeref(sprintf('angle%d.ref',angle), mncnleavezeros(ddists(:,i)));
%    end
end

