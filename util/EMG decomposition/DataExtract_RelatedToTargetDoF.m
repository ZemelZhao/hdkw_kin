% Extracting data of target DoF(finger)
function [vData,vActionIndex,vRestIndex] = DataExtract_RelatedToTargetDoF(vData_Raw,vLabel,iFingerIndex,fSamp)

fRestRange = 2.5;    % Time length of rest data (s)
iRestDataNum = fRestRange*fSamp;

iDataNum = size(vData_Raw,2);

vLabel_Finger_Raw = vLabel(iFingerIndex,:);
vLabel_Finger = zeros(1,size(vLabel_Finger_Raw,2));

vOtherFingerIndex = setdiff(1:5,iFingerIndex);
vLabel_Other = sum(vLabel(vOtherFingerIndex,:));

iIndex = 1;
iIndex_Begin = 1;
while(iIndex<iDataNum)
    if(vLabel_Finger_Raw(iIndex)-vLabel_Finger_Raw(iIndex+1)==-1)
        if(vLabel_Other(iIndex+1)==0)
            vLabel_Finger(iIndex-iRestDataNum+1:iIndex)=1;
            iIndex = iIndex+1;
            iIndex_Begin = iIndex;
        else
            iIndex = iIndex+1;
        end
    elseif(vLabel_Finger_Raw(iIndex)-vLabel_Finger_Raw(iIndex+1)==1)
        if(vLabel_Other(iIndex)==0)
            vLabel_Finger(iIndex+1:iIndex+iRestDataNum)=1;
            vLabel_Finger(iIndex_Begin:iIndex)=1;
            iIndex = iIndex+iRestDataNum+1;
        else
            iIndex = iIndex+1;
        end
    else
        iIndex = iIndex+1;
    end  
end

vFingerRelatedIndex = find(vLabel_Finger==1);

vLabel_Extract = zeros(1,iDataNum);
vActionIndex = find(vLabel(iFingerIndex,:)==1);
vRestIndex = setdiff(vFingerRelatedIndex,vActionIndex);
vLabel_Extract(vActionIndex)=2;
vLabel_Extract(vRestIndex)=1;
vLabel_Extract(find(vLabel_Extract==0))=[];
vActionIndex = find(vLabel_Extract==2);
vRestIndex = find(vLabel_Extract==1);

vData = vData_Raw(:,vFingerRelatedIndex);

end