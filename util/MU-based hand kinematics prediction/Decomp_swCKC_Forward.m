function vResult_swCKC_Forward = Decomp_swCKC_Forward(vEMGList,vParameters_swCKC_Forward)

iElectrodeNum = size(vEMGList,2);
vSpikeList_swCKC = cell(1,iElectrodeNum);
vPNRList_swCKC = cell(1,iElectrodeNum);
vSILList_swCKC = cell(1,iElectrodeNum);

vCtxList = vParameters_swCKC_Forward.vCtxList;
vWList = vParameters_swCKC_Forward.vWList;
vCentroidsList = vParameters_swCKC_Forward.vCentroidsList;
vTrialIndexofMUList = vParameters_swCKC_Forward.vTrialIndexofMUList;
vChannelSpatial_FarField = vParameters_swCKC_Forward.vChannelSpatial_FarField;
vChannelSpatial_NearField = vParameters_swCKC_Forward.vChannelSpatial_NearField;
vValidChannelList = vParameters_swCKC_Forward.vValidChannelList;

% Executing on each electrode
for iElectrodeIndex=1:iElectrodeNum
    vEMG = vEMGList{1,iElectrodeIndex};
    vCtx = vCtxList{1,iElectrodeIndex};
    vW = vWList{1,iElectrodeIndex};
    vCentroids = vCentroidsList{1,iElectrodeIndex};
    vTrialIndexofMU = vTrialIndexofMUList{1,iElectrodeIndex};
    iMUNum = size(vTrialIndexofMU,2);

    if(iElectrodeIndex<=4)
        vChannelSpatial = vChannelSpatial_FarField;
    else
        vChannelSpatial = vChannelSpatial_NearField;
    end

    % Forward decomposition
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

    vSpikeList_swCKC{1,iElectrodeIndex} = vSpikeList;
    vPNRList_swCKC{1,iElectrodeIndex} = vPNRList;
    vSILList_swCKC{1,iElectrodeIndex} = vSILList;
end

vResult_swCKC_Forward.vSpikeList_swCKC = vSpikeList_swCKC;
vResult_swCKC_Forward.vPNRList_swCKC = vPNRList_swCKC;
vResult_swCKC_Forward.vSILList_swCKC = vSILList_swCKC;