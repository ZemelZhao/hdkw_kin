function [vFS,vF]=CalFS(vData, fSamp)

vFS = abs(fft(vData));
vF = linspace(0,fSamp,size(vFS,2));

end