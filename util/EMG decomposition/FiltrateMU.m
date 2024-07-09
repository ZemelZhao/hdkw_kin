function vValidMUIndexList=FiltrateMU(vMUList,vPNRList)

%%%%%Paramters for determing the whether the decoded MU is valid%%%%%%
fCoVISIThreshold_MUST = 0.45;           % Threshold of coefficient of variation of inter-spike interval
fISIThreshold_Top = 0.2;                % Upper bound during inter-spike interval calculation 
fISIThreshold_Bottom = 0.02;            % Lower bound during inter-spike interval calculation
fMeanFRThreshold_MUST = 35;             % Threshold of average firing rate
fPNRThreshold_MUST = 25;                % Threshold of pulse-to-noise ratio
fRoAThreshold = 0.3;                    % Threshold of index for evaluating similarity between MUSTs (RoA)
iShiftMax_RoA = 4;                      % Maximum shift during RoA calculation
iLagMax_RoA = 100;                      % Maximum lag during RoA calculation
%%%%%%%%%%%%%%%%%%%%%

fSamp = 2000;

iMUNum = size(vMUList,2);

vValidMUIndexList = ones(1,iMUNum);

%%%%%First round (based on the charateristics of a single MU)%%%%%
for iMUIndex=1:iMUNum

    % Coefficient of variation of inter-spike interval
    fCoVISI = CalCoVISI(vMUList{1,iMUIndex}, fSamp, fISIThreshold_Top, fISIThreshold_Bottom);
    if(fCoVISI>fCoVISIThreshold_MUST)
        vValidMUIndexList(1,iMUIndex)=0;
    end

    % Firing rate
    fMeanFR = CalMeanFR(vMUList{1,iMUIndex}, fSamp, fISIThreshold_Top);
    if(fMeanFR>fMeanFRThreshold_MUST)
        vValidMUIndexList(1,iMUIndex)=0;
    end

    % Pulse-to noise ratio
    fPNR = vPNRList(1,iMUIndex);
    if(fPNR<fPNRThreshold_MUST)
        vValidMUIndexList(1,iMUIndex)=0;
    end

    % Number of spikes
    iSpikeNum = length(vMUList{1,iMUIndex});
    if(iSpikeNum<5*5)
        vValidMUIndexList(1,iMUIndex)=0;
    end
end


%%%%%Second round (similarity between MUSTs)%%%%%
for iMUIndex=1:iMUNum
    if(vValidMUIndexList(1,iMUIndex)==1)
        for iMUIndex_Cmp=1:iMUIndex-1
            if(vValidMUIndexList(1,iMUIndex_Cmp)==1)
                fRoA = CalRoA_Mine(vMUList{1,iMUIndex},vMUList{1,iMUIndex_Cmp},iShiftMax_RoA,iLagMax_RoA);   
                if(fRoA>fRoAThreshold)
                    vValidMUIndexList(1,iMUIndex)=0;
                end
            end
        end
    end
end

vValidMUIndexList=find(vValidMUIndexList==1);

end