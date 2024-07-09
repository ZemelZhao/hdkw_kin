function vValidChannel_1D = ValidChannelReshape_2DTo1D(vValidChannel_2D,vChannelSpatial)

iChannelNum = sum(sum(sign(vChannelSpatial)));

iRowNum = size(vValidChannel_2D,1);
iColNum = size(vValidChannel_2D,2);

vValidChannel_1D = zeros(1,iChannelNum);
for iRowIndex=1:iRowNum
    for iColIndex=1:iColNum
        if(vChannelSpatial(iRowIndex,iColIndex)~=0 && vValidChannel_2D(iRowIndex,iColIndex)==1)
			vValidChannel_1D(vChannelSpatial(iRowIndex,iColIndex)) = 1;
        end
    end
end