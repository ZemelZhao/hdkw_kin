clc
clear


%% Parameter Defining
sSubjectIndex = '03';
vTrainTrialIndex = [1,2,3,5,6];   % Trials for determing CKC separation parameters and training LR model
iTestTrialIndex = 4;              % Trails for test
iTargetDoFIndex = 1;             % Estimated DoF (proximal joint of thumb)
vElectrodeChannelNumList = [64,64,64,64,64,64,64];
iTrialNum = 6;
iElectrodeNum = length(vElectrodeChannelNumList);
fSamp_EMG = 2000;    % Sampling frequency of EMG data (Hz)
fSamp_Glove = 200;   % Sampling frequency of glove data  (Hz)
fTrialTimeLength = 187;    % Time length of a single trial data  (s)

fWindowTime = 0.3;   % Time length of a single sliding window
fStepTime = 0.1;     % Time length of sliding step
pca_dim = 200;       % Number of dimensions after PCA
iLag = 2;            % Considering electric-mechanical delay (200ms)


%% Data Loading
% EMG and glove data
vEMGList = cell(1,iTrialNum);
vGloveList = cell(1,iTrialNum);
for iTrialIndex = 1:iTrialNum
    load(['H:\zmz\sci_data\data\data\glove\subject_' sSubjectIndex '\hdkw_kin_exp03_subj' sSubjectIndex '_' num2str(iTrialIndex) '.mat']); 
    vEMGList{1,iTrialIndex} = data.emg;
    vGloveList{1,iTrialIndex} = data.glove(iTargetDoFIndex,:); 
end


%% Data Preprocessing
% EMG filtering
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

    vEMGList{1,iTrialIndex} = Filtering(vEMGList{1,iTrialIndex},bIfBandPassFilter,vFilterParameter_BandPass,bIfCombFilter,vFilterParameter_Comb,bIfSpaceFilter,vFilterParameter_Space,fSamp_EMG);
end

% Normalization of glove data
fMax = max([max(vGloveList{1,1}),max(vGloveList{1,2}),max(vGloveList{1,3}),max(vGloveList{1,4}),max(vGloveList{1,5}),max(vGloveList{1,6})]);
fMin = min([min(vGloveList{1,1}),min(vGloveList{1,2}),min(vGloveList{1,3}),min(vGloveList{1,4}),min(vGloveList{1,5}),min(vGloveList{1,6})]);
for iTrialIndex = 1:iTrialNum
    vGloveList{1,iTrialIndex} = (vGloveList{1,iTrialIndex}-fMin)/(fMax-fMin);
end


%% Data Processing
%%% Extraction of training data %%%
% EMG data
vEMGList_FarField_Train = [];
vEMGList_NearField_Train = [];
for iTrialIndex = vTrainTrialIndex
    vEMGList_FarField_Train = [vEMGList_FarField_Train vEMGList{1,iTrialIndex}(1:256,:)];
    vEMGList_NearField_Train = [vEMGList_NearField_Train vEMGList{1,iTrialIndex}(257:448,:)];
end
% Motion data
vMotionList_Train = [];
for iTrialIndex = vTrainTrialIndex
    vMotionList_Train = [vMotionList_Train vGloveList{1,iTrialIndex}];
end
% Motion data sampling
vMotionList_Sampling_Train = [];
iIndex = 1;
while(iIndex+floor(fWindowTime*fSamp_Glove)<=size(vMotionList_Train,2)+1)
    vMotionList_Sampling_Train(:,end+1) = mean(vMotionList_Train(:,iIndex:iIndex+floor(fWindowTime*fSamp_Glove)-1),2);
    iIndex = iIndex+floor(fStepTime*fSamp_Glove);
end
vMotionList_Train = vMotionList_Sampling_Train;

%%% Extraction of test data %%%
% EMG data
vEMG_Test = vEMGList{1,iTestTrialIndex};
vEMG_FarField_Test = vEMG_Test(1:256,:);
vEMG_NearField_Test = vEMG_Test(257:448,:);
% Motion data
vMotion_Test = vGloveList{1,iTestTrialIndex};
% Motion data sampling
vMotion_Sampling_Test = [];
iIndex = 1;
while(iIndex+floor(fWindowTime*fSamp_Glove)<=size(vMotion_Test,2)+1)
    vMotion_Sampling_Test(:,end+1) = mean(vMotion_Test(:,iIndex:iIndex+floor(fWindowTime*fSamp_Glove)-1),2);
    iIndex = iIndex+floor(fStepTime*fSamp_Glove);
end
vMotion_Test = vMotion_Sampling_Test;


%% Feature calculation
% Fearture of training data
vTF_FarField_Train = CalRMS(vEMGList_FarField_Train',fWindowTime,fStepTime,fSamp_EMG);
vTF_NearField_Train = CalRMS(vEMGList_NearField_Train',fWindowTime,fStepTime,fSamp_EMG);
vTF_FarField_Train = vTF_FarField_Train';
vTF_NearField_Train = vTF_NearField_Train';

% Fearture of test data
vTF_FarField_Test = CalRMS(vEMG_FarField_Test',fWindowTime,fStepTime,fSamp_EMG);
vTF_NearField_Test = CalRMS(vEMG_NearField_Test',fWindowTime,fStepTime,fSamp_EMG);
vTF_FarField_Test = vTF_FarField_Test';
vTF_NearField_Test = vTF_NearField_Test';

% Dimensionality reduction based on PCA
[vTF_FarField_Train,vTF_FarField_Test] = FeatureNormalization(vTF_FarField_Train,vTF_FarField_Test,1,pca_dim);
[vTF_NearField_Train,vTF_NearField_Test] = FeatureNormalization(vTF_NearField_Train,vTF_NearField_Test,1,pca_dim);


%% Multiple Linear Regression 
%%% LR model training %%%
% Bias adding
vTF_FarField_Train = [ones(1,size(vTF_FarField_Train,2)); vTF_FarField_Train];
vTF_NearField_Train = [ones(1,size(vTF_NearField_Train,2)); vTF_NearField_Train];
iDim_Train = size(vTF_FarField_Train,2);
% Lag adding  (Considering electric-mechanical delay (200ms))
vTF_FarField_Train = vTF_FarField_Train(:,max(1,1-iLag):min(iDim_Train,iDim_Train-iLag));
vTF_NearField_Train = vTF_NearField_Train(:,max(1,1-iLag):min(iDim_Train,iDim_Train-iLag));
vMotion_Train = vMotionList_Train(1,max(1,1+iLag):min(iDim_Train,iDim_Train+iLag));
% Training
vRegressParameter_FarField = regress(vMotion_Train(1,:)',vTF_FarField_Train');
vRegressParameter_NearField = regress(vMotion_Train(1,:)',vTF_NearField_Train');

%%% LR model testing %%%
% Bias adding
vTF_FarField_Test = [ones(1,size(vTF_FarField_Test,2)); vTF_FarField_Test];
vTF_NearField_Test = [ones(1,size(vTF_NearField_Test,2)); vTF_NearField_Test];
iDim_Test = size(vTF_FarField_Test,2);
% Lag adding  (Considering electric-mechanical delay (200ms))
vTF_FarField_Test = vTF_FarField_Test(:,max(1,1-iLag):min(iDim_Test,iDim_Test-iLag));
vTF_NearField_Test = vTF_NearField_Test(:,max(1,1-iLag):min(iDim_Test,iDim_Test-iLag));
vMotion_Test = vMotion_Test(1,max(1,1+iLag):min(iDim_Test,iDim_Test+iLag));
% Motion estimating
vMotionEstimate_FarField = (vTF_FarField_Test'*vRegressParameter_FarField)';
vMotionEstimate_NearField = (vTF_NearField_Test'*vRegressParameter_NearField)';


%% Result evaluation
% Calculating pearson coefficient
fR_FarField = CalR(vMotionEstimate_FarField',vMotion_Test);
fR_NearField = CalR(vMotionEstimate_NearField',vMotion_Test);