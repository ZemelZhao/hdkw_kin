function vMUAPList = EstimateMUAP_Multi_MMSE(vEMG, vSpikeIndexList, iMUAPLength)

iRowNum = size(vEMG,1);
iColNum = size(vEMG,2);
iTrainLength = length(vEMG{1,1});
iMUNum = length(vSpikeIndexList);

for iMUIndex = 1:length(vSpikeIndexList)
    vSpikeIndex = vSpikeIndexList{1,iMUIndex};
    vDeleteIndex = [];
    for iIndex = 1:length(vSpikeIndex)
        if(vSpikeIndex(iIndex)-iMUAPLength/2<0 || vSpikeIndex(iIndex)+iMUAPLength/2>iTrainLength)
            vDeleteIndex(end+1) = iIndex;
        end
    end
    vSpikeIndex(vDeleteIndex) = [];
    vSpikeIndexList{1,iMUIndex} = vSpikeIndex;
end

vX = EMGReshape_2DTo1D(vEMG);
vX = vX';


vS = [[]];

for iMUIndex = 1:iMUNum
    for iBiasIndex = 1:iMUAPLength
        iBias = -iMUAPLength/2+iBiasIndex;
        vSpikeIndex_Bias = vSpikeIndexList{1,iMUIndex} + iBias;
        vSpikeTrain_Bias = zeros(1,iTrainLength);
        vSpikeTrain_Bias(vSpikeIndex_Bias)=1;
        
        vS(end+1,:) = vSpikeTrain_Bias;
    end
end

vS = vS';


vMUAPList = cell(1,iMUNum);
vH = pinv(vS'*vS)*vS'*vX;

for iMUIndex = 1:iMUNum
    vMUAP = cell(iRowNum, iColNum);
    vH_Single = vH((iMUIndex-1)*iMUAPLength+1:iMUIndex*iMUAPLength,:);
    vH_Single = vH_Single';
    
    iChannelIndex = 1;
    for iRowIndex=1:iRowNum
        for iColIndex=1:iColNum
            vMUAP{iRowIndex,iColIndex}=vH_Single(iChannelIndex,:);
            iChannelIndex=iChannelIndex+1;
        end
    end
    
    vMUAPList{1,iMUIndex} = vMUAP;
end