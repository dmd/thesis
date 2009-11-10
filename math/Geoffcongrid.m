function NewSignal = Geoffcongrid(Signal,NewSize)
% note this only works with vertically oriented ones
%
% 2007 ddrucker@psych.upenn.edu

OrigLength=size(Signal,1);
Ratio=NewSize/OrigLength;
if Ratio ~= floor(Ratio)
    error('ratio is not integer');
end
nSimMats=size(Signal,2);
NewSignal=zeros(NewSize,nSimMats);


for i=1:Ratio
    NewSignal(i:Ratio:Ratio*(OrigLength-1)+i,:) = Signal;
end
