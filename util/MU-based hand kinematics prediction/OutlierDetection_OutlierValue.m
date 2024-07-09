function vEMG = OutlierDetection_OutlierValue(vEMG_Raw,fCoefficient,iWindowLength)

iRowNum = size(vEMG_Raw,1);
iColNum = size(vEMG_Raw,2);

vEMG = cell(iRowNum,iColNum);
iDataNum = size(vEMG_Raw{1,2},2);

if(length(iWindowLength)==0)
    iWindowLength = iDataNum;
end

for iRowIndex=1:iRowNum
    for iColIndex=1:iColNum
        if(length(vEMG_Raw{iRowIndex,iColIndex})~=0)
            vEMG_Channel = vEMG_Raw{iRowIndex,iColIndex};
            
            iBeginIndex = 1;
            while(iBeginIndex+iWindowLength<=iDataNum+1)
                vEMG_Channel_Window = vEMG_Channel(1,iBeginIndex:iBeginIndex+iWindowLength-1);
                
                fMean = mean(abs(vEMG_Channel_Window));
                vAbnormalIndex = find(abs(vEMG_Channel_Window)>fCoefficient*fMean);
            
                vEMG_Channel_Window(vAbnormalIndex)=0;
                
                vEMG_Channel(1,iBeginIndex:iBeginIndex+iWindowLength-1)=vEMG_Channel_Window;
                
                iBeginIndex = iBeginIndex+iWindowLength;
            end
            
            vEMG_Channel_Window = vEMG_Channel(1,iBeginIndex:iDataNum);
            
            fMean = mean(abs(vEMG_Channel_Window));
            vAbnormalIndex = find(abs(vEMG_Channel_Window)>fCoefficient*fMean);

            vEMG_Channel_Window(vAbnormalIndex)=0;

            vEMG_Channel(1,iBeginIndex:iDataNum)=vEMG_Channel_Window;

            vEMG{iRowIndex,iColIndex} = vEMG_Channel;    
        end
    end
end