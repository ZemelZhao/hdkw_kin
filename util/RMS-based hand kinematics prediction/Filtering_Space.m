function vEMG = Filtering_Space(vEMG_Raw, vFilter, vStep)

iRowNum_Raw = size(vEMG_Raw,1);
iColNum_Raw = size(vEMG_Raw,2);
iDataNum = size(vEMG_Raw{1,1},2);

iRowNum_Filter = size(vFilter,1);
iColNum_Filter = size(vFilter,2);

iRowStep = vStep(1,1);
iColStep = vStep(1,2);

iRowNum_EMG = 0;
while(1)
    if(iRowNum_Filter+iRowNum_EMG*iRowStep<=iRowNum_Raw)
        iRowNum_EMG = iRowNum_EMG+1;
    else
        break;
    end
end

iColNum_EMG = 0;
while(1)
    if(iColNum_Filter+iColNum_EMG*iColStep<=iColNum_Raw)
        iColNum_EMG = iColNum_EMG+1;
    else
        break;
    end
end

vEMG = cell(iRowNum_EMG,iColNum_EMG);

iRowIndex = 1;
for i=1:iRowNum_EMG
    iColIndex = 1;
    for j=1:iColNum_EMG
        vEMG_Single = zeros(1,iDataNum);
        for m=1:iRowNum_Filter
            for n=1:iColNum_Filter
                vEMG_Single = vEMG_Single+vFilter(m,n)*vEMG_Raw{iRowIndex+m-1,iColIndex+n-1};
            end
        end
        vEMG{i,j} = vEMG_Single;
        iColIndex = iColIndex + iColStep;
    end
    iRowIndex = iRowIndex + iRowStep;
end