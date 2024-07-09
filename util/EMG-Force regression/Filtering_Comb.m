function vEMG = Filtering_Comb(vEMG_Raw, vFrequencyList, fFilterQ, fSamp)

vEMG = zeros(size(vEMG_Raw));

iFrequencyNum = size(vFrequencyList,2);

vFilterList_A = cell(1,iFrequencyNum);
vFilterList_B = cell(1,iFrequencyNum);

for iIndex = 1:size(vFrequencyList,2)
    fFrequency_Notch = vFrequencyList(1,iIndex);
    [B,A] = iirnotch(fFrequency_Notch/fSamp*2, fFrequency_Notch/fSamp*2/fFilterQ);
    vFilterList_A{1,iIndex} = A;
    vFilterList_B{1,iIndex} = B;
end


for i=1:size(vEMG_Raw,1)
    for j=1:iFrequencyNum
        vEMG_Raw(i,:) = filtfilt(vFilterList_B{1,j},vFilterList_A{1,j},vEMG_Raw(i,:));
    end
end

vEMG = vEMG_Raw;