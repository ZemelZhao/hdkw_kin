function vSpikeTrain = SpikeIndexToSpikeTrain(vSpikeIndex, iTrainLength)

iMUNum = size(vSpikeIndex,2);

vSpikeTrain = zeros(iMUNum, iTrainLength);

for iMUIndex=1:iMUNum
    vSpikeTrain(iMUIndex,vSpikeIndex{1,iMUIndex}) = 1;
end