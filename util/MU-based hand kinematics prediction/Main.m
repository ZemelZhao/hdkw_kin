clc
clear


%% Parameter Defining
sSubjectIndex = '03';
vTrainTrialIndex = [1,2,3,5,6];                     % Trials for determing CKC separation parameters and training LR model
iTestTrialIndex = 4;                                % Trails for test
iTargetDoFIndex = 1;                                % Estimated DoF (proximal joint of thumb)
vElectrodeChannelNumList = [64,64,64,64,64,64,64];  % Number of electrode channels
iTrialNum = 6;
iElectrodeNum = length(vElectrodeChannelNumList);   % Number of electrodes
fSamp_EMG = 2000;                                   % Sampling frequency of EMG data (Hz)
fSamp_Glove = 200;                                  % Sampling frequency of glove data  (Hz)
fTrialTimeLength = 187;                             % Time length of a single trial data  (s)

fWindowTime = 0.3;    % Time length of sliding window during CST calculation  (s)
fStepTime = 0.1;      % Time length of sliding step during CST calculation  (s)


%% Data Loading
% EMG and glove data
vEMGList = cell(iTrialNum,iElectrodeNum);
vGloveList = cell(1,iTrialNum);
for iTrialIndex = 1:iTrialNum
    load(['H:\zmz\sci_data\data\data\glove\subject_' sSubjectIndex '\hdkw_kin_exp03_subj' sSubjectIndex '_' num2str(iTrialIndex) '.mat']); 
    vEMG_Split =  EMGSplit_SingleElectrode(data.emg,vElectrodeChannelNumList);
    for iElectrodeIndex = 1:iElectrodeNum
        vEMGList{iTrialIndex,iElectrodeIndex} = vEMG_Split{iElectrodeIndex};
    end
    vGloveList{1,iTrialIndex} = data.glove(iTargetDoFIndex,:); 
end

% Spatial layout of electrode channel
load('ChannelSpatial_0808.mat');
vChannelSpatial_NearField = vChannelSpatial; 
load('ChannelSpatial_0513.mat');
vChannelSpatial_FarField = vChannelSpatial;


%% Data Preprocessing
% EMG filtering
for iTrialIndex = 1:iTrialNum
    for iElectrodeIndex = 1:iElectrodeNum
        bIfBandPassFilter = true;
        bIfCombFilter = true;
        bIfSpaceFilter = false;
        vFilterParameter_BandPass.iButterOrder = 4;
        vFilterParameter_BandPass.vFrequencyInterval = [20 500];
        vFilterParameter_Comb.vFrequencyList = 50:50:500;
        vFilterParameter_Comb.fFilterQ = 100;
        vFilterParameter_Space.vFilter =[[1 -1];[-1 1]];
        vFilterParameter_Space.vStep = [1 1];
        
        vEMGList{iTrialIndex,iElectrodeIndex} = Filtering(vEMGList{iTrialIndex,iElectrodeIndex},bIfBandPassFilter,vFilterParameter_BandPass,bIfCombFilter,vFilterParameter_Comb,bIfSpaceFilter,vFilterParameter_Space,fSamp_EMG);
    end
end

% Outlier channel detection
vValidChannelList = cell(iTrialNum,iElectrodeNum);
for iTrialIndex = 1:iTrialNum
    for iElectrodeIndex = 1:iElectrodeNum
        if(iElectrodeIndex<5)
            vChannelSpatial = vChannelSpatial_FarField;
        else
            vChannelSpatial = vChannelSpatial_NearField;
        end
        vEMG_2D = OutlierDetection_OutlierValue(EMGReshape_1DTo2D(vEMGList{iTrialIndex,iElectrodeIndex},vChannelSpatial),16,[]);
        [~,vNormalChannel] = OutlierDetection_OutlierChannel_PautaCriterion(vEMG_2D,0.85);
        vValidChannelList{iTrialIndex,iElectrodeIndex} = vNormalChannel;
    end
end

% Glove data normalization
fMax = max([max(vGloveList{1,1}),max(vGloveList{1,2}),max(vGloveList{1,3}),max(vGloveList{1,4}),max(vGloveList{1,5}),max(vGloveList{1,6})]);
fMin = min([min(vGloveList{1,1}),min(vGloveList{1,2}),min(vGloveList{1,3}),min(vGloveList{1,4}),min(vGloveList{1,5}),min(vGloveList{1,6})]);
vGloveList{1,1} = (vGloveList{1,1}-fMin)/(fMax-fMin);
vGloveList{1,2} = (vGloveList{1,2}-fMin)/(fMax-fMin);
vGloveList{1,3} = (vGloveList{1,3}-fMin)/(fMax-fMin);
vGloveList{1,4} = (vGloveList{1,4}-fMin)/(fMax-fMin);
vGloveList{1,5} = (vGloveList{1,5}-fMin)/(fMax-fMin);
vGloveList{1,6} = (vGloveList{1,6}-fMin)/(fMax-fMin);


%% EMG Decomposition by gCKC
vWList = cell(iTrialNum,iElectrodeNum); 
vCtxList = cell(iTrialNum,iElectrodeNum);
vCentroidsList = cell(iTrialNum,iElectrodeNum);
vRawMUNumList = cell(iTrialNum,iElectrodeNum);
for iTrialIndex = 1:iTrialNum
    for iElectrodeIndex = 1:iElectrodeNum
        if(iElectrodeIndex<5)
            vChannelSpatial = vChannelSpatial_FarField;
        else
            vChannelSpatial = vChannelSpatial_NearField;
        end
        
        vResult_CKC = Decomp_CKC(vEMGList{iTrialIndex,iElectrodeIndex}, vChannelSpatial);
        vWList{iTrialIndex,iElectrodeIndex} = vResult_CKC.vW_Valid;
        vCtxList{iTrialIndex,iElectrodeIndex} = vResult_CKC.vCtx_Valid;
        vCentroidsList{iTrialIndex,iElectrodeIndex} = vResult_CKC.vCentroids_Valid;
        vRawMUNumList{iTrialIndex,iElectrodeIndex} = size(vResult_CKC.vSpikeIndex_Valid,2);
    end
end


%% swCKC decomposition on train trials
vParameters_swCKC.vValidChannelList = vValidChannelList;
vParameters_swCKC.vChannelSpatial_NearField = vChannelSpatial_NearField;
vParameters_swCKC.vChannelSpatial_FarField = vChannelSpatial_FarField;
vParameters_swCKC.vTrainTrialIndex = vTrainTrialIndex;
vDecompParameters_gCKC.vWList = vWList;
vDecompParameters_gCKC.vCtxList = vCtxList;
vDecompParameters_gCKC.vCentroidsList = vCentroidsList;
vDecompParameters_gCKC.vRawMUNumList = vRawMUNumList;
vParameters_swCKC.vDecompParameters_gCKC = vDecompParameters_gCKC;
vResult_swCKC = Decomp_swCKC(vEMGList, vParameters_swCKC);
vSpikeList_swCKC_Train = vResult_swCKC.vSpikeList_swCKC_Deduplicate;


%% swCKC decomposition on test trial
vEMGList_Test = vEMGList(iTestTrialIndex,:);
vParameters_swCKC_Forward.vCtxList = vResult_swCKC.vCtxList_swCKC_Deduplicate;
vParameters_swCKC_Forward.vWList = vResult_swCKC.vWList_swCKC_Deduplicate;
vParameters_swCKC_Forward.vCentroidsList = vResult_swCKC.vCentroidsList_swCKC_Deduplicate;
vParameters_swCKC_Forward.vTrialIndexofMUList = vResult_swCKC.vTrialIndexofMU_swCKC_Deduplicate;
vParameters_swCKC_Forward.vChannelSpatial_FarField = vChannelSpatial_FarField;
vParameters_swCKC_Forward.vChannelSpatial_NearField = vChannelSpatial_NearField;
vParameters_swCKC_Forward.vValidChannelList = vValidChannelList;
vResult_swCKC_Forward = Decomp_swCKC_Forward(vEMGList_Test,vParameters_swCKC_Forward);
vSpikeList_swCKC_Test = vResult_swCKC_Forward.vSpikeList_swCKC;


%% Training data generation
% Spike list
vSpikeList_Train_FarField = cell(1,0);
vSpikeList_Train_NearField = cell(1,0);
for iElectrodeIndex = 1:4
    vSpikeList_Train_FarField = [vSpikeList_Train_FarField, vSpikeList_swCKC_Train{1,iElectrodeIndex}];
end
for iElectrodeIndex = 5:7
    vSpikeList_Train_NearField = [vSpikeList_Train_NearField, vSpikeList_swCKC_Train{1,iElectrodeIndex}];
end
% CST
vMUST_FarField_Train = SpikeIndexToSpikeTrain(vSpikeList_Train_FarField, length(vTrainTrialIndex)*fSamp_EMG*fTrialTimeLength);
vMUST_NearField_Train = SpikeIndexToSpikeTrain(vSpikeList_Train_NearField, length(vTrainTrialIndex)*fSamp_EMG*fTrialTimeLength);
vCST_FarField_Train = [];
vCST_NearField_Train = [];
for iMUIndex = 1:size(vMUST_FarField_Train,1)
    vCST_FarField_Train = [vCST_FarField_Train; CalCST(vMUST_FarField_Train(iMUIndex,:),floor(fWindowTime*fSamp_EMG),floor(fStepTime*fSamp_EMG))];
end
for iMUIndex = 1:size(vMUST_NearField_Train,1)
    vCST_NearField_Train = [vCST_NearField_Train; CalCST(vMUST_NearField_Train(iMUIndex,:),floor(fWindowTime*fSamp_EMG),floor(fStepTime*fSamp_EMG))];
end
% Motion
vMotion_Train = [];
for iTrialIndex = vTrainTrialIndex
    vMotion_Train = [vMotion_Train vGloveList{1,iTrialIndex}];
end
vMotion_Sampling_Train = [];
iIndex = 1;
while(iIndex+floor(fWindowTime*fSamp_Glove)<=size(vMotion_Train,2))
    vMotion_Sampling_Train(:,end+1) = mean(vMotion_Train(:,iIndex:iIndex+floor(fWindowTime*fSamp_Glove)-1),2);
    iIndex = iIndex+floor(fStepTime*fSamp_Glove);
end
vMotion_Train = vMotion_Sampling_Train;


%% Testing data generation
% Spike list
vSpikeList_Test_FarField = cell(1,0);
vSpikeList_Test_NearField = cell(1,0);
for iElectrodeIndex = 1:4
    vSpikeList_Test_FarField = [vSpikeList_Test_FarField, vSpikeList_swCKC_Test{1,iElectrodeIndex}];
end
for iElectrodeIndex = 5:7
    vSpikeList_Test_NearField = [vSpikeList_Test_NearField, vSpikeList_swCKC_Test{1,iElectrodeIndex}];
end
% CST
vMUST_FarField_Test = SpikeIndexToSpikeTrain(vSpikeList_Test_FarField, fSamp_EMG*fTrialTimeLength);
vMUST_NearField_Test = SpikeIndexToSpikeTrain(vSpikeList_Test_NearField, fSamp_EMG*fTrialTimeLength);
vCST_FarField_Test = [];
vCST_NearField_Test = [];
for iMUIndex = 1:size(vMUST_FarField_Test,1)
    vCST_FarField_Test = [vCST_FarField_Test; CalCST(vMUST_FarField_Test(iMUIndex,:),floor(fWindowTime*fSamp_EMG),floor(fStepTime*fSamp_EMG))];
end
for iMUIndex = 1:size(vMUST_NearField_Test,1)
    vCST_NearField_Test = [vCST_NearField_Test; CalCST(vMUST_NearField_Test(iMUIndex,:),floor(fWindowTime*fSamp_EMG),floor(fStepTime*fSamp_EMG))];
end
% Motion
vMotion_Test = vGloveList{iTestTrialIndex};
vMotion_Sampling_Test = [];
iIndex = 1;
while(iIndex+floor(fWindowTime*fSamp_Glove)<=size(vMotion_Test,2))
    vMotion_Sampling_Test(:,end+1) = mean(vMotion_Test(:,iIndex:iIndex+floor(fWindowTime*fSamp_Glove)-1),2);
    iIndex = iIndex+floor(fStepTime*fSamp_Glove);
end
vMotion_Test = vMotion_Sampling_Test;


%% Force estimation based on multi linear regression
% Training
% Bias adding
vCST_FarField_Train = [ones(1,size(vCST_FarField_Train,2)); vCST_FarField_Train];
vCST_NearField_Train = [ones(1,size(vCST_NearField_Train,2)); vCST_NearField_Train];
% Regress
vRegressParameter_FarField = regress(vMotion_Train',vCST_FarField_Train');
vRegressParameter_NearField = regress(vMotion_Train',vCST_NearField_Train');

% Testing
vCST_FarField_Test = [ones(1,size(vCST_FarField_Test,2)); vCST_FarField_Test];
vCST_NearField_Test = [ones(1,size(vCST_NearField_Test,2)); vCST_NearField_Test];
% Estimating
vMotionEstimated_FarField = vCST_FarField_Test'*vRegressParameter_FarField;
vMotionEstimated_NearField = vCST_NearField_Test'*vRegressParameter_NearField;

% Evaluation
fR_FarField = CalR(vMotion_Test,vMotionEstimated_FarField);
fR_NearField = CalR(vMotion_Test,vMotionEstimated_NearField);