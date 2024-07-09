function fMUAPSimilarity = CalMUAPSimilarity(vMUAP_1, vMUAP_2, fC, iLagMax, vTime)

iRowNum = size(vMUAP_1,1);
iColNum = size(vMUAP_1,2);

vMUAPSimilarityList = [];

for iLag = -iLagMax:iLagMax

    vD = [];
    vW = [];


    for iRowIndex=1:iRowNum
        for iColIndex=1:iColNum
            vMUAP_1_Single = vMUAP_1{iRowIndex, iColIndex};
            vMUAP_2_Single = vMUAP_2{iRowIndex, iColIndex};

            vMUAP_2_Single_Extend = zeros(1,length(vMUAP_2_Single)+2*abs(iLag));
            vMUAP_2_Single_Extend(1,abs(iLag)+1:1:abs(iLag)+length(vMUAP_2_Single)) = vMUAP_2_Single;
            if(iLag<0)
                vMUAP_2_Single = vMUAP_2_Single_Extend(1,1:1:length(vMUAP_2_Single));
            else
                vMUAP_2_Single = vMUAP_2_Single_Extend(1,2*abs(iLag)+1:1:length(vMUAP_2_Single)+2*abs(iLag));
            end

            if(length(vTime)~=0)
                vMUAP_1_Single = vMUAP_1_Single(vTime(1,1):1:vTime(1,2));
                vMUAP_2_Single = vMUAP_2_Single(vTime(1,1):1:vTime(1,2));
            end

           fD = sum((vMUAP_1_Single-vMUAP_2_Single).*(vMUAP_1_Single-vMUAP_2_Single));
           fW = sum((abs(vMUAP_1_Single)+abs(vMUAP_2_Single)).*(abs(vMUAP_1_Single)+abs(vMUAP_2_Single)));
           vD(end+1) = sum((vMUAP_1_Single-vMUAP_2_Single).*(vMUAP_1_Single-vMUAP_2_Single));
           vW(end+1) = sum((abs(vMUAP_1_Single)+abs(vMUAP_2_Single)).*(abs(vMUAP_1_Single)+abs(vMUAP_2_Single)));
        end
    end

    fMUAPSimilarity_Lag = 1 - sum(vD.*power(vW,fC-1))/sum(power(vW,fC));
    
    vMUAPSimilarityList(end+1) = fMUAPSimilarity_Lag;
end

fMUAPSimilarity = max(vMUAPSimilarityList);


end