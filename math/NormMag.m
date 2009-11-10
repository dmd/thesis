function NewImage = NormMag(Image)
%
% 2007 ddrucker@psych.upenn.edu adapted from gka

FTImage=fft(Image);

MagImage=sqrt(FTImage.*conj(FTImage));
ZeroPoints=find(MagImage==0);
ZeroCount=length(ZeroPoints);
if ZeroCount > 0
    MagImage(ZeroPoints)=1;
end
PhaseImage=acos(real(FTImage./MagImage));
NegVals=find(imag(FTImage) < 0);
NegCount=length(NegVals);
if NegCount > 0
    PhaseImage(NegVals) = 2*pi - PhaseImage(NegVals);
end
if ZeroCount > 0
    PhaseImage(ZeroPoints) = 0;
    MagImage(ZeroPoints) = 0;
end
MagImage=MagImage./max(MagImage);
RealPart=MagImage.*cos(PhaseImage);
ImaginaryPart=MagImage.*sin(PhaseImage);
FTImage=complex(RealPart,ImaginaryPart);
NewImage=real(ifft(FTImage));

end
