function vSpikeIndex = SpikeTrainToSpikeIndex(vSpikeTrain)

    iMUNum = size(vSpikeTrain,1);

    vSpikeIndex = cell(1,iMUNum);

    for iMUIndex=1:iMUNum
        vSpikeIndex{1,iMUIndex} = find(vSpikeTrain(iMUIndex,:)==1);
    end

end