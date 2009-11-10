function ImScrambled = phasescramble(image,frac)

if nargin<2
    frac=1;
end

Im = mat2gray(double(image));

%read and rescale (0-1) image
ImSize = size(Im);


%generate random phase structure

for layer = 1:ImSize(3)
%Fast-Fourier transform
    ImFourier(:,:,layer) = fft2(Im(:,:,layer));       
%amplitude spectrum
    Amp(:,:,layer) = abs(ImFourier(:,:,layer));       
%phase spectrum
    
Phase(:,:,layer) = angle(ImFourier(:,:,layer));   
p = Phase(:,:,layer);
p=p(:);
p=shuffle(p);
p=reshape(p,size(Phase(:,:,layer)));
Phase(:,:,layer)=p;
    
    
    %combine Amp and Phase then perform inverse Fourier
    ImScrambled(:,:,layer) = ifft2(Amp(:,:,layer).*exp(sqrt(-1)*(Phase(:,:,layer))));   
end

ImScrambled = real(ImScrambled); %get rid of imaginery part in image (due to rounding error)
% imwrite(ImScrambled,'BearScrambled.jpg','jpg');

imshow(ImScrambled)
