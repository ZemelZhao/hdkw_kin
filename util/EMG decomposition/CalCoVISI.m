function fCoVISI = CalCoVISI(vSpikeIndex, fSamp, fISIThreshold_Top, fISIThreshold_Bottom)

iSpikeNum = length(vSpikeIndex);

vISIList = [];
for iSpikeIndex = 1:iSpikeNum-1
    fISI = (vSpikeIndex(iSpikeIndex+1)-vSpikeIndex(iSpikeIndex))/fSamp;
    if(fISI<=fISIThreshold_Top && fISI>=fISIThreshold_Bottom)
        vISIList(end+1) = fISI;
    end
end

if(~isempty(vISIList))
    fStd = std(vISIList);
    fMean = mean(vISIList);
    fCoVISI = fStd/fMean;
else
    fCoVISI = 0;
end