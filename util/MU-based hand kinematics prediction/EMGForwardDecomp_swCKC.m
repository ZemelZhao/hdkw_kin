function [vSpikeList,vPNRList,vSILList] = EMGForwardDecomp_swCKC(vEMG_Extend,vInvCorrSig,vCtx,vCentroids,iExtendFactor)

iMUNum = size(vCtx,1);

vSpikeList = cell(1,iMUNum);
vPNRList = zeros(1,iMUNum); 
vSILList = zeros(1,iMUNum);

vIPTList_Raw = vCtx*vInvCorrSig*vEMG_Extend;
for iMUIndex = 1:iMUNum
    
    vIPT_MU_Raw = vIPTList_Raw(iMUIndex,:);
    vIPT_MU_Raw([1:iExtendFactor,end-iExtendFactor+1:end]) = 0;
    vIPT_MU = abs(vIPT_MU_Raw).*vIPT_MU_Raw;
    if -min(vIPT_MU_Raw)>max(vIPT_MU_Raw)
        vIPT_MU(find(vIPT_MU_Raw>0)) = 0;     
    else
        vIPT_MU(find(vIPT_MU_Raw<0)) = 0;
    end
    vIPT_MU = abs(vIPT_MU(iExtendFactor+1:end-iExtendFactor));
    

    fC1 = vCentroids(iMUIndex,1);
    fC2 = vCentroids(iMUIndex,2);
    fCAve = (fC1+fC2)/2;
    vSpike_MU_Raw = find(vIPT_MU>fCAve);

    iIntervalLimit = 20;
    vSpike_MU = RemRepeatedInd(vIPT_MU,vSpike_MU_Raw,iIntervalLimit); 

    fPNR = pnr(vSpike_MU,vIPT_MU);
    fSIL = sil(vSpike_MU,vIPT_MU);
    
    vSpikeList{1,iMUIndex} = vSpike_MU;
    vPNRList(1,iMUIndex) = fPNR;
    vSILList(1,iMUIndex) = fSIL;   
end