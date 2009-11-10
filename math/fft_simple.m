function []=fft_simple(signal)

% function []=fft_simple(signal)

x = signal;
pt = length(signal);

n = 0:600;

figure
subplot(2,1,1)
plot(x(1:pt));
title('Input Signal')
xlabel('sample number')

subplot(2,1,2)
X = fft(x, pt);
Pxx = X.* conj(X) / pt;
f = 100*(0:(pt-1))/pt;
plot(f,Pxx);
title('Frequency content of x (Input signal)')
xlabel('frequency (Hz)')
