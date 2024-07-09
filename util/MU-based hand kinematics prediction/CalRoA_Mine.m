function fRoA = CalRoA_Mine(vSpikeIndex_Pre,vSpikeIndex_Truth,iShiftMax,iLagMax)

vRoAList = [];

for iLag = -iLagMax:iLagMax

    vSpikeIndex_Pre_Lag = vSpikeIndex_Pre + iLag;
    
    vSpikeIndex_Pre_Lag_Shift = [];
    for iShift = -iShiftMax:iShiftMax
        vSpikeIndex_Pre_Lag_Shift = [vSpikeIndex_Pre_Lag_Shift vSpikeIndex_Pre_Lag+iShift];
    end
    
    iTP = length(intersect(vSpikeIndex_Pre_Lag_Shift,vSpikeIndex_Truth));
    iFP = length(vSpikeIndex_Pre)-iTP;
    iFN = length(vSpikeIndex_Truth)-iTP;
    
    vRoAList(end+1) = iTP/(iTP+iFP+iFN);
    
    if(isnan(vRoAList(end)))
        vRoAList(end) = 0;
    end
end

[~,iIndex_Optimal] = max(vRoAList);


fRoA = vRoAList(iIndex_Optimal);