function vRetainedMUIndexList = EliminateRepeatedMUs(vSpikeIndexList_Raw,vPNRList,fThreshold)

iMUNum_Raw = size(vSpikeIndexList_Raw,2);

vLabel = ones(1,iMUNum_Raw);

for iIndex_1=1:iMUNum_Raw-1
    vSpike_1 = vSpikeIndexList_Raw{1,iIndex_1};
    vTmp_1 = [iIndex_1];
    vTmp_2 = [vPNRList(iIndex_1)];
    for iIndex_2=iIndex_1+1:iMUNum_Raw
        if(vLabel(iIndex_2)==1)
            vSpike_2 = vSpikeIndexList_Raw{1,iIndex_2};
            fRoA = CalRoA_Mine(vSpike_1,vSpike_2,20,1);
            if(fRoA>=fThreshold)
                vTmp_1(end+1) = iIndex_2;
                vTmp_2(end+1) = vPNRList(iIndex_2);
            end
        end
    end
    
    if(length(vTmp_1)>1)
        [~,iOptimalIndex] = max(vTmp_2);
        vTmp_1(iOptimalIndex)=[];
        vLabel(vTmp_1) = 0;
    end
end

vRetainedMUIndexList = find(vLabel==1);