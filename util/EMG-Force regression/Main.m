clc
clear


%% Parameter Defining
sSubjectIndex = '01';
sTargetMVC = '40';                  % MVC level
vTrainTrialIndex = [1,3,4,5,6];   % Trials for training LR model
iTestTrialIndex = 2;              % Trails for test
iTargetDoFIndex = 1;              % Estimated DoF (thumb)
iTrialNum = 6;
fSamp_EMG = 2000;    % Sampling frequency of EMG data (Hz)
fSamp_Press = 1000;   % Sampling frequency of press data  (Hz)

fWindowTime = 0.3;   % Time length of a single sliding window
fStepTime = 0.1;     % Time length of sliding step
pca_dim = 50;       % Number of dimensions after PCA
iLag = 2;            % Considering electric-mechanical delay (200ms)


%% Data Loading
% EMG and press data
vEMGList_FarField = cell(1,iTrialNum);    % EMG data of far-field
vEMGList_NearField = cell(1,iTrialNum);   % EMG data of near-field
vPressList = cell(1,iTrialNum);           % Press data
vValidChannelList_FarField = cell(1,iTrialNum);   % Valid channel list of far-field EMG
vValidChannelList_NearField = cell(1,iTrialNum);  % Valid channel list of near-field EMG
for iTrialIndex = 1:iTrialNum
    load(['H:\zmz\sci_data\data\data\press\subject_' sSubjectIndex '\hdkw_kin_exp02_subj' sSubjectIndex '_' num2str(iTrialIndex) '.mat']); 
    if(strcmp(sTargetMVC,'20'))
        vEMGList_FarField{1,iTrialIndex} = data.emg_20(1:256,:);
        vEMGList_NearField{1,iTrialIndex} = data.emg_20(257:448,:);
        vPressList{1,iTrialIndex} = data.press_20(iTargetDoFIndex,:);
    else
        vEMGList_FarField{1,iTrialIndex} = data.emg_40(1:256,:);
        vEMGList_NearField{1,iTrialIndex} = data.emg_40(257:448,:);
        vPressList{1,iTrialIndex} = data.press_40(iTargetDoFIndex,:);
    end
end


%% Data Preprocessing
% EMG data filtering
for iTrialIndex = 1:iTrialNum
    bIfBandPassFilter = true;
    bIfCombFilter = true;
    bIfSpaceFilter = false;
    vFilterParameter_BandPass.iButterOrder = 4;
    vFilterParameter_BandPass.vFrequencyInterval = [20 500];
    vFilterParameter_Comb.vFrequencyList = 50:50:500;
    vFilterParameter_Comb.fFilterQ = 100;
    vFilterParameter_Space.vFilter =[[1 -1];[-1 1]];
    vFilterParameter_Space.vStep = [1 1];
    vEMGList_NearField{1,iTrialIndex} = Filtering(vEMGList_NearField{1,iTrialIndex},bIfBandPassFilter,vFilterParameter_BandPass,bIfCombFilter,vFilterParameter_Comb,bIfSpaceFilter,vFilterParameter_Space,fSamp_EMG);
    vEMGList_FarField{1,iTrialIndex} = Filtering(vEMGList_FarField{1,iTrialIndex},bIfBandPassFilter,vFilterParameter_BandPass,bIfCombFilter,vFilterParameter_Comb,bIfSpaceFilter,vFilterParameter_Space,fSamp_EMG);  
end

% Press data resampling
for iTrialIndex = 1:iTrialNum
    vPress_Sampling = [];
    for i=1:floor(fStepTime*fSamp_Press):(size(vPressList{1,iTrialIndex},2)-floor(fWindowTime*fSamp_Press)+1)
        vPress_Sampling(end+1) = mean(vPressList{1,iTrialIndex}(:,i:i+floor(fWindowTime*fSamp_Press)-1),2);
    end
    vPressList{1,iTrialIndex} = vPress_Sampling;
end


%% Feature calculation
vTF_NearField = cell(1,iTrialNum);    % Time-domain features of near-field
vTF_FarField = cell(1,iTrialNum);     % Time-domain features of far-field 
for iTrialIndedx = 1:iTrialNum
    % Four kinds of time-domain features   1:RMS  2:WL  3:ZC  4:SSC
    vTF_NearField_All = cell(1,iTrialNum,4);
    vTF_FarField_All = cell(1,iTrialNum,4);
    for iTrialIndex=1:iTrialNum
        vTF_FarField_All{1,iTrialIndex,1} = (CalRMS((vEMGList_FarField{1,iTrialIndex})',fWindowTime,fStepTime,fSamp_EMG))';
        vTF_FarField_All{1,iTrialIndex,2} = (CalWL((vEMGList_FarField{1,iTrialIndex})',fWindowTime,fStepTime,fSamp_EMG))';
        vTF_FarField_All{1,iTrialIndex,3} = (CalZC((vEMGList_FarField{1,iTrialIndex})',fWindowTime,fStepTime,0.4,fSamp_EMG))';
        vTF_FarField_All{1,iTrialIndex,4} = (CalSSC((vEMGList_FarField{1,iTrialIndex})',fWindowTime,fStepTime,0.4,fSamp_EMG))';

        vTF_NearField_All{1,iTrialIndex,1} = (CalRMS((vEMGList_NearField{1,iTrialIndex})',fWindowTime,fStepTime,fSamp_EMG))';
        vTF_NearField_All{1,iTrialIndex,2} = (CalWL((vEMGList_NearField{1,iTrialIndex})',fWindowTime,fStepTime,fSamp_EMG))';
        vTF_NearField_All{1,iTrialIndex,3} = (CalZC((vEMGList_NearField{1,iTrialIndex})',fWindowTime,fStepTime,0.4,fSamp_EMG))';
        vTF_NearField_All{1,iTrialIndex,4} = (CalSSC((vEMGList_NearField{1,iTrialIndex})',fWindowTime,fStepTime,0.4,fSamp_EMG))';
    end
end 
% Feature merging
for iTrialIndex=1:iTrialNum
    for iTFIndex=1:4
        vTF_FarField{1,iTrialIndex} = [vTF_FarField{1,iTrialIndex}; vTF_FarField_All{1,iTrialIndex,iTFIndex}];
        vTF_NearField{1,iTrialIndex} = [vTF_NearField{1,iTrialIndex}; vTF_NearField_All{1,iTrialIndex,iTFIndex}];
    end
end
% Training and testing data extraction
vTF_NearField_Train = [];
vTF_FarField_Train = [];
vPress_Train = [];
for iTrialIndex = vTrainTrialIndex
    vTF_NearField_Train = [vTF_NearField_Train vTF_NearField{1,iTrialIndex}];
    vTF_FarField_Train = [vTF_FarField_Train vTF_FarField{1,iTrialIndex}];
    vPress_Train = [vPress_Train vPressList{1,iTrialIndex}];
end
vTF_NearField_Test = vTF_NearField{1,iTestTrialIndex};
vTF_FarField_Test = vTF_FarField{1,iTestTrialIndex};
vPress_Test = vPressList{1,iTestTrialIndex};
% PCA
[vTF_FarField_Train,vTF_FarField_Test] = FeatureNormalization(vTF_FarField_Train,vTF_FarField_Test,1,pca_dim);
[vTF_NearField_Train,vTF_NearField_Test] = FeatureNormalization(vTF_NearField_Train,vTF_NearField_Test,1,pca_dim);


%% Multiple Linear Regression 
%%% LR model training %%%
% Bias adding
vTF_FarField_Train = [ones(1,size(vTF_FarField_Train,2)); vTF_FarField_Train];
vTF_FarField_Test = [ones(1,size(vTF_FarField_Test,2)); vTF_FarField_Test];
vTF_NearField_Train = [ones(1,size(vTF_NearField_Train,2)); vTF_NearField_Train];
vTF_NearField_Test = [ones(1,size(vTF_NearField_Test,2)); vTF_NearField_Test];

% LR model training
vRegressParameter_FarField = regress(vPress_Train',vTF_FarField_Train');
vRegressParameter_NearField = regress(vPress_Train',vTF_NearField_Train');

% LR model testing
vForceEstimate_FarField = vTF_FarField_Test'*vRegressParameter_FarField;
vForceEstimate_NearField = vTF_NearField_Test'*vRegressParameter_NearField;  

% Evaluation
fRMSE_FarField = CalRMSE(vForceEstimate_FarField,vPress_Test');
fRMSE_NearField = CalRMSE(vForceEstimate_NearField,vPress_Test');