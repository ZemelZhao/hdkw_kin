function [vCST,vIndex] = CalCST(vMUST,iWindowSize,iStepSize)

vCST = [];
vIndex = [];

iIndex = 1;

while(iIndex+iWindowSize<=size(vMUST,2))
    vCST(end+1) = sum(sum(vMUST(:,iIndex:iIndex+iWindowSize-1)));
    vIndex(end+1) = iIndex+iWindowSize/2-1;
    iIndex = iIndex+iStepSize;
end

end