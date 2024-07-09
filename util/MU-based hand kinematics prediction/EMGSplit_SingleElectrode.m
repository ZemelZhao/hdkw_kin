function vEMGList=EMGSplit_SingleElectrode(vEMG_Raw,vChannelNumList)

iElectrodeNum = size(vChannelNumList,2);

vEMGList = cell(1,iElectrodeNum);

iChannelIndex_Begin = 1;

for iElectrodeIndex=1:iElectrodeNum
    iChannelNum = vChannelNumList(1,iElectrodeIndex);
    vEMGList{1,iElectrodeIndex} = vEMG_Raw(iChannelIndex_Begin:iChannelIndex_Begin+iChannelNum-1,:);
    
    iChannelIndex_Begin = iChannelIndex_Begin+iChannelNum;
end

end