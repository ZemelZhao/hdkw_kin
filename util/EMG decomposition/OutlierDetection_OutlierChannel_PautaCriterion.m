function [vEMG,vNormalChannel_vPautaCriterion] = OutlierDetection_OutlierChannel_PautaCriterion(vEMG_Raw,fThreshold_PautaCriterion)

iRowNum = size(vEMG_Raw,1);
iColNum = size(vEMG_Raw,2);

vEMG = cell(iRowNum,iColNum);

vPautaCriterion = zeros(iRowNum,iColNum);
for iRowIndex=1:iRowNum
    for iColIndex=1:iColNum
        if(length(vEMG_Raw{iRowIndex,iColIndex})~=0)
            vPautaCriterion(iRowIndex,iColIndex) = CalPautaCriterion(vEMG_Raw{iRowIndex,iColIndex});
        end
    end
end

vNormalChannel_vPautaCriterion = zeros(iRowNum,iColNum);
for iRowIndex=1:iRowNum
    for iColIndex=1:iColNum
        if(vPautaCriterion(iRowIndex,iColIndex)>=fThreshold_PautaCriterion)
            vNormalChannel_vPautaCriterion(iRowIndex,iColIndex) = 1;
        end  
    end
end

for iRowIndex=1:iRowNum
    for iColIndex=1:iColNum
        if(vNormalChannel_vPautaCriterion(iRowIndex,iColIndex)==1)
            vEMG{iRowIndex,iColIndex}=vEMG_Raw{iRowIndex,iColIndex};
        end
    end
end