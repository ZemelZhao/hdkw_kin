function vEMG = EMGReshape_1DTo2D(vEMG_Raw, vChannelSpatial)

iChannelNum = size(vEMG_Raw,1);
iDataNum = size(vEMG_Raw,2);

iRowNum = size(vChannelSpatial,1);
iColNum = size(vChannelSpatial,2);

vEMG = cell(iRowNum,iColNum);

for iRowIndex = 1:iRowNum
	for iColIndex = 1:iColNum
		if(vChannelSpatial(iRowIndex,iColIndex)~=0)
			vEMG{iRowIndex,iColIndex} = vEMG_Raw(vChannelSpatial(iRowIndex,iColIndex),:);
		else
			vEMG{iRowIndex,iColIndex} = [];
		end
	end
end

end