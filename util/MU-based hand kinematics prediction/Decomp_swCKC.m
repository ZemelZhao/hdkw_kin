function vResult_swCKC = Decomp_swCKC(vEMGList,vParameters_swCKC)

iTrialNum = size(vEMGList,1);
iElectrodeNum = size(vEMGList,2);

vSpikeList_swCKC_Raw = cell(1,iElectrodeNum);
vCtxList_swCKC_Raw = cell(1,iElectrodeNum);
vWList_swCKC_Raw = cell(1,iElectrodeNum);
vCentroidsList_swCKC_Raw = cell(1,iElectrodeNum);
vTrialIndexofMU_swCKC_Raw = cell(1,iElectrodeNum);
vPNRList_swCKC_Raw = cell(1,iElectrodeNum);
vSpikeList_swCKC_Deduplicate = cell(1,iElectrodeNum);
vCtxList_swCKC_Deduplicate = cell(1,iElectrodeNum);
vWList_swCKC_Deduplicate = cell(1,iElectrodeNum);
vCentroidsList_swCKC_Deduplicate = cell(1,iElectrodeNum);
vTrialIndexofMU_swCKC_Deduplicate = cell(1,iElectrodeNum);
vPNRList_swCKC_Deduplicate = cell(1,iElectrodeNum);

vValidChannelList = vParameters_swCKC.vValidChannelList;

vTrainTrialIndex = vParameters_swCKC.vTrainTrialIndex;

vDecompParameters_gCKC = vParameters_swCKC.vDecompParameters_gCKC;
vWList = vDecompParameters_gCKC.vWList;
vCtxList = vDecompParameters_gCKC.vCtxList;
vCentroidsList = vDecompParameters_gCKC.vCentroidsList;
vRawMUNumList = vDecompParameters_gCKC.vRawMUNumList;

vChannelSpatial_NearField = vParameters_swCKC.vChannelSpatial_NearField; 
vChannelSpatial_FarField = vParameters_swCKC.vChannelSpatial_FarField;


%% Data preprocessing
% EMG concatenation
vEMG_Merge = cell(1,iElectrodeNum);
for iElectrodeIndex = 1:iElectrodeNum
    for iIndex = vTrainTrialIndex
        vEMG_Merge{1,iElectrodeIndex} = [vEMG_Merge{1,iElectrodeIndex},vEMGList{iIndex,iElectrodeIndex}];
    end
end

% Decomposition parameters contenation
vW_Merge = cell(1,iElectrodeNum);
vCtx_Merge = cell(1,iElectrodeNum);
vCentroids_Merge = cell(1,iElectrodeNum);
for iElectrodeIndex = 1:iElectrodeNum
    for iIndex = vTrainTrialIndex
        vW_Merge{1,iElectrodeIndex} = [vW_Merge{1,iElectrodeIndex},vWList{iIndex,iElectrodeIndex}];
        vCtx_Merge{1,iElectrodeIndex} = [vCtx_Merge{1,iElectrodeIndex},vCtxList{iIndex,iElectrodeIndex}];
        vCentroids_Merge{1,iElectrodeIndex} = [vCentroids_Merge{1,iElectrodeIndex},vCentroidsList{iIndex,iElectrodeIndex}];
    end
end

% MU index after concantenation
vTrialIndexofMU_Merge = cell(1,iElectrodeNum);
for iElectrodeIndex = 1:iElectrodeNum
    vTrialIndexofMU_Merge_Electrode = [];
    for iIndex = vTrainTrialIndex
        iMUNum = vRawMUNumList{iIndex,iElectrodeIndex};
        for iMUIndex = 1:iMUNum
            vTrialIndexofMU_Merge_Electrode(end+1) = iIndex;
        end
    end
    vTrialIndexofMU_Merge{1,iElectrodeIndex} = vTrialIndexofMU_Merge_Electrode;
end


%% swCKC decomposition on each electrode 
for iElectrodeIndex=1:iElectrodeNum
    vEMG = vEMG_Merge{1,iElectrodeIndex};
    vCtx = vCtx_Merge{1,iElectrodeIndex};
    vW = vW_Merge{1,iElectrodeIndex};
    vCentroids = vCentroids_Merge{1,iElectrodeIndex};
    vTrialIndexofMU = vTrialIndexofMU_Merge{1,iElectrodeIndex};
    iMUNum = size(vTrialIndexofMU,2);

    if(iElectrodeIndex< 5)
        vChannelSpatial = vChannelSpatial_FarField;
    else
        vChannelSpatial = vChannelSpatial_NearField;
    end

    vSpikeList = cell(1,iMUNum);
    vPNRList = zeros(1,iMUNum);
    vSILList = zeros(1,iMUNum);
    iTrialIndexofMU_Pre = 0;
    for iMUIndex=1:iMUNum
        iTrialIndexofMU = vTrialIndexofMU(iMUIndex);

        if(iTrialIndexofMU == iTrialIndexofMU_Pre)
            [vSpike,vPNR,vSIL] = EMGForwardDecomp_swCKC(vEMG_Valid_Extend,vInvCorrSig,vCtx{1,iMUIndex}',vCentroids{1,iMUIndex},iExtendFactor);

            vSpikeList{1,iMUIndex} = vSpike{1,1};
            vPNRList(1,iMUIndex) = vPNR(1);
            vSILList(1,iMUIndex) = vSIL(1);
        else
            vValidChannel_1D = ValidChannelReshape_2DTo1D(vValidChannelList{iTrialIndexofMU,iElectrodeIndex},vChannelSpatial);
            vEMG_Valid = vEMG(find(vValidChannel_1D==1),:);

            iExtendFactor = 10;
            vEMG_Valid_Extend = Extend(vEMG_Valid,iExtendFactor);

            vCorrSig = (vEMG_Valid_Extend(:,iExtendFactor+1:end-iExtendFactor))*(vEMG_Valid_Extend(:,iExtendFactor+1:end-iExtendFactor))'/size(vEMG_Valid_Extend(:,iExtendFactor+1:end-iExtendFactor),2);
            vInvCorrSig = pinv(vCorrSig);

            [vSpike,vPNR,vSIL] = EMGForwardDecomp_swCKC(vEMG_Valid_Extend,vInvCorrSig,vCtx{1,iMUIndex}',vCentroids{1,iMUIndex},iExtendFactor);

            vSpikeList{1,iMUIndex} = vSpike{1,1};
            vPNRList(1,iMUIndex) = vPNR(1);
            vSILList(1,iMUIndex) = vSIL(1);
        end

        iTrialIndexofMU_Pre = iTrialIndexofMU;
    end

    vRetainedMUIndexList = EliminateRepeatedMUs(vSpikeList,vPNRList,0.3);

    vSpikeList_swCKC_Raw{1,iElectrodeIndex} = vSpikeList;
    vCtxList_swCKC_Raw{1,iElectrodeIndex} = vCtx;
    vWList_swCKC_Raw{1,iElectrodeIndex} = vW;
    vCentroidsList_swCKC_Raw{1,iElectrodeIndex} = vCentroids;
    vTrialIndexofMU_swCKC_Raw{1,iElectrodeIndex} = vTrialIndexofMU;
    vPNRList_swCKC_Raw{1,iElectrodeIndex} = vPNRList;
    vSpikeList_swCKC_Deduplicate{1,iElectrodeIndex} = vSpikeList(vRetainedMUIndexList);
    vCtxList_swCKC_Deduplicate{1,iElectrodeIndex} = vCtx(vRetainedMUIndexList);
    vWList_swCKC_Deduplicate{1,iElectrodeIndex} = vW(vRetainedMUIndexList);
    vCentroidsList_swCKC_Deduplicate{1,iElectrodeIndex} = vCentroids(vRetainedMUIndexList);
    vTrialIndexofMU_swCKC_Deduplicate{1,iElectrodeIndex} = vTrialIndexofMU(vRetainedMUIndexList);
    vPNRList_swCKC_Deduplicate{1,iElectrodeIndex} = vPNRList(vRetainedMUIndexList);
end

vResult_swCKC.vSpikeList_swCKC_Raw = vSpikeList_swCKC_Raw;
vResult_swCKC.vCtxList_swCKC_Raw = vCtxList_swCKC_Raw;
vResult_swCKC.vWList_swCKC_Raw = vWList_swCKC_Raw;
vResult_swCKC.vCentroidsList_swCKC_Raw = vCentroidsList_swCKC_Raw;
vResult_swCKC.vTrialIndexofMU_swCKC_Raw = vTrialIndexofMU_swCKC_Raw;
vResult_swCKC.vPNRList_swCKC_Raw = vPNRList_swCKC_Raw;
vResult_swCKC.vSpikeList_swCKC_Deduplicate = vSpikeList_swCKC_Deduplicate;
vResult_swCKC.vCtxList_swCKC_Deduplicate = vCtxList_swCKC_Deduplicate;
vResult_swCKC.vWList_swCKC_Deduplicate = vWList_swCKC_Deduplicate;
vResult_swCKC.vCentroidsList_swCKC_Deduplicate = vCentroidsList_swCKC_Deduplicate;
vResult_swCKC.vTrialIndexofMU_swCKC_Deduplicate = vTrialIndexofMU_swCKC_Deduplicate;
vResult_swCKC.vPNRList_swCKC_Deduplicate = vPNRList_swCKC_Deduplicate;