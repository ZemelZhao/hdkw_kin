function [vPSD,vF]=CalPSD(vData, fSamp)

vDataCorr = xcorr(vData,'unbiased');

vPSD = abs(fft(vDataCorr));
vF = linspace(0,fSamp,size(vPSD,2));

end