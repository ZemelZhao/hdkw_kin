function fMeanFR = CalMeanFR(vSpikeIndex, fSamp, fISIThreshold_ReSpike)

iSpikeNum = length(vSpikeIndex);

vISIList = [];
for iSpikeIndex = 1:iSpikeNum-1
    fISI = (vSpikeIndex(iSpikeIndex+1)-vSpikeIndex(iSpikeIndex))/fSamp;
    if(fISI <= fISIThreshold_ReSpike)
        vISIList(end+1) = fISI;
    end
end

if(~isempty(vISIList))
    fMeanFR = mean(1./vISIList);
else
    fMeanFR = 0;
end