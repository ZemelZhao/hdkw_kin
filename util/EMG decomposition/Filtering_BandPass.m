function vEMG = Filtering_BandPass(vEMG_Raw, iButterOrder, vFrequencyInterval, fSamp)

vEMG = zeros(size(vEMG_Raw));

fFrequency_Low = vFrequencyInterval(1,1);
fFrequency_High = vFrequencyInterval(1,2);
 
[b, a] = butter(iButterOrder,[fFrequency_Low/fSamp*2 fFrequency_High/fSamp*2]);

for i=1:size(vEMG_Raw,1)
    vEMG(i,:) = filtfilt(b,a,vEMG_Raw(i,:));
end