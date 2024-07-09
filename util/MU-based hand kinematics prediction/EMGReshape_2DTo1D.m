function vEMG = EMGReshape_2DTo1D(vEMG_Raw,vChannelSpatial)

iChannelNum = max(max(vChannelSpatial));

iRowNum = size(vEMG_Raw,1);
iColNum = size(vEMG_Raw,2);

for iRowIndex=1:iRowNum
    for iColIndex=1:iColNum
        if(~isempty(vEMG_Raw{iRowIndex,iColIndex}))
            iDataNum = size(vEMG_Raw{iRowIndex,iColIndex},2);
        end
    end
end

vEMG = zeros(iChannelNum,iDataNum);
vAbnormalChannel = [];

for iRowIndex=1:iRowNum
    for iColIndex=1:iColNum
        if(vChannelSpatial(iRowIndex,iColIndex)~=0 && length(vEMG_Raw{iRowIndex,iColIndex})~=0)
			vEMG(vChannelSpatial(iRowIndex,iColIndex),:)=vEMG_Raw{iRowIndex,iColIndex};
        end
        if(vChannelSpatial(iRowIndex,iColIndex)~=0 && length(vEMG_Raw{iRowIndex,iColIndex})==0)
            vAbnormalChannel(end+1) = vChannelSpatial(iRowIndex,iColIndex);
        end
    end
end


if(length(vAbnormalChannel)~=0)
    vEMG(vAbnormalChannel,:)=[];
end