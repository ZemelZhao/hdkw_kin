clc
clear


%% Parameter Defining
sSubjectIndex = '01';
sTargetMVC = '40';                % MVC level
vTrainTrialIndex = [1,3,4,5,6];   % Trials for training LR model
iTargetTrialIndex = 2;            % Target trial
iTargetDoFIndex = 1;              % Estimated DoF (thumb)
iElectrodeNum_NearField = 3;      % Number of near-field electrodes
iElectrodeNum_FarField = 4;       % Number of far-field electrodes
fSamp_EMG = 2000;    % Sampling frequency of EMG data (Hz)
fSamp_Press = 1000;   % Sampling frequency of press data  (Hz)

fWindowTime = 0.25;   % Time length of a single sliding window for CST calculation
fStepTime = 0.1;     % Time length of sliding step for CST calculation


%% Data Loading
% EMG and press data
load(['H:\zmz\sci_data\data\data\press\subject_' sSubjectIndex '\hdkw_kin_exp02_subj' sSubjectIndex '_' num2str(iTargetTrialIndex) '.mat']); 
if(strcmp(sTargetMVC,'20'))
    vEMG_FarField = data.emg_20(1:256,:);
    vEMG_NearField = data.emg_20(257:448,:);
    vPress = data.press_20(iTargetDoFIndex,:);
else
    vEMG_FarField = data.emg_40(1:256,:);
    vEMG_NearField = data.emg_40(257:448,:);
    vPress = data.press_40(iTargetDoFIndex,:);
end

% Activited finger label
load('Label_EMG.mat');
vLabel_EMG = vLabel;
load('Label_Press.mat');
vLabel_Press = vLabel;

% Spatial layout of electrode channel
load('ChannelSpatial_0808.mat');
vChannelSpatial_NearField = vChannelSpatial;   
load('ChannelSpatial_0513.mat');
vChannelSpatial_FarField = vChannelSpatial;


%% Data Preprocessing
% EMG data
% Target DoF data extraction
[vEMG_NearField,~,~] = DataExtract_RelatedToTargetDoF(vEMG_NearField,vLabel_EMG,iTargetDoFIndex,fSamp_EMG);
[vEMG_FarField,~,~] = DataExtract_RelatedToTargetDoF(vEMG_FarField,vLabel_EMG,iTargetDoFIndex,fSamp_EMG);
% Filtering
bIfBandPassFilter = true;
bIfCombFilter = true;
bIfSpaceFilter = false;
vFilterParameter_BandPass.iButterOrder = 4;
vFilterParameter_BandPass.vFrequencyInterval = [20 500];
vFilterParameter_Comb.vFrequencyList = 50:50:500;
vFilterParameter_Comb.fFilterQ = 100;
vFilterParameter_Space.vFilter =[[1 -1];[-1 1]];
vFilterParameter_Space.vStep = [1 1];
vEMG_NearField = Filtering(vEMG_NearField,bIfBandPassFilter,vFilterParameter_BandPass,bIfCombFilter,vFilterParameter_Comb,bIfSpaceFilter,vFilterParameter_Space,fSamp_EMG);
vEMG_FarField = Filtering(vEMG_FarField,bIfBandPassFilter,vFilterParameter_BandPass,bIfCombFilter,vFilterParameter_Comb,bIfSpaceFilter,vFilterParameter_Space,fSamp_EMG);  

% Press data
% Target DoF data extraction
vPress = DataExtract_RelatedToTargetDoF(vPress,vLabel_Press,iTargetDoFIndex,fSamp_Press); 
% Resampling (1000Hz->2000Hz)
vT_Train_Raw = 1:2:2*size(vPress,2);
vT_Train_New = 1:1:2*size(vPress,2);
vPress = interp1(vT_Train_Raw,vPress,vT_Train_New,'linear');


%% EMG decomposition based on gCKC
% This part aims to obtain the raw decomposition results
vMU_FarField = [];      % Spikes of MUs decoded from each electrode of far-field 
vPNR_FarField = [];     % PNR of each decoded MUs of far-field
vMU_NearField = [];        % Spikes of MUs decoded from each electrode of near-field       
vPNR_NearField = [];     % PNR of each decoded MUs of near-field
% Near-field
for iElectrodeIndex = 1:iElectrodeNum_NearField
    % Outlier detection
    vEMG_2D = EMGReshape_1DTo2D(vEMG_NearField((iElectrodeIndex-1)*64+1:iElectrodeIndex*64,:),vChannelSpatial_NearField);
    vEMG_2D = OutlierDetection_OutlierValue(vEMG_2D,16,[]);
    [vEMG_2D,vNormalChannel] = OutlierDetection_OutlierChannel_PautaCriterion(vEMG_2D,0.85);
    vEMG_1D = EMGReshape_2DTo1D(vEMG_2D,vChannelSpatial_NearField);
    % Decomposition
    vResult_CKC = Decomp_CKC(vEMG_1D);

    vMU_NearField = [vMU_NearField vResult_CKC.vSpikeIndex_Decomps];
    vPNR_NearField = [vPNR_NearField vResult_CKC.vPNRs_Decomps];
end
% Far-field
for iElectrodeIndex = 1:iElectrodeNum_FarField
    % Outlier detection
    vEMG_2D = EMGReshape_1DTo2D(vEMG_FarField((iElectrodeIndex-1)*64+1:iElectrodeIndex*64,:),vChannelSpatial_FarField);
    vEMG_2D = OutlierDetection_OutlierValue(vEMG_2D,16,[]);
    [vEMG_2D,vNormalChannel] = OutlierDetection_OutlierChannel_PautaCriterion(vEMG_2D,0.85);
    vEMG_1D = EMGReshape_2DTo1D(vEMG_2D,vChannelSpatial_FarField);
    % Decomposition
    vResult_CKC = Decomp_CKC(vEMG_1D);

    vMU_FarField = [vMU_FarField vResult_CKC.vSpikeIndex_Decomps];
    vPNR_FarField = [vPNR_FarField vResult_CKC.vPNRs_Decomps];
end


%% Validate MUs Filtration
% Based on coefficient of variation of inter-spike interval, firing rate, pulse-to-noise ratio, etc.
vValidMUIndex_FarField=FiltrateMU(vMU_FarField,vPNR_FarField);
vValidMUIndex_NearField=FiltrateMU(vMU_NearField,vPNR_NearField);
vMU_FarField = vMU_FarField(vValidMUIndex_FarField);
vMU_NearField = vMU_NearField(vValidMUIndex_NearField);


%% MU-based Force Estimation
% MUST generation
vMUST_FarField = SpikeIndexToSpikeTrain(vMU_FarField, 10*fSamp_EMG);
vMUST_NearField = SpikeIndexToSpikeTrain(vMU_NearField, 10*fSamp_EMG);

% CST calculation
vCST_FarField = [];
for iMUIndex = 1:size(vMUST_FarField,1)
    [vCST_FarField_Single,vCSTIndex_FarField] = CalCST(vMUST_FarField(iMUIndex,:),fWindowTime*fSamp_EMG,fStepTime*fSamp_EMG);
    vCST_FarField = [vCST_FarField; vCST_FarField_Single];
end
vCST_NearField = [];
for iMUIndex = 1:size(vMUST_NearField,1)
    [vCST_NearField_Single,vCSTIndex_NearField] = CalCST(vMUST_NearField(iMUIndex,:),fWindowTime*fSamp_EMG,fStepTime*fSamp_EMG);
    vCST_NearField = [vCST_NearField; vCST_NearField_Single];
end

% Multi linear regression
vPress_FarField = vPress(vCSTIndex_FarField);
vPress_NearField = vPress(vCSTIndex_NearField);
vRegressParameter_FarField = regress(vPress_FarField',vCST_FarField');
vRegressParameter_NearField = regress(vPress_NearField',vCST_NearField');
vForceEstimated_FarField = vRegressParameter_FarField'*vCST_FarField;
vForceEstimated_NearField = vRegressParameter_NearField'*vCST_NearField;

% Evaluation
fR_FarField = CalR(vForceEstimated_FarField, vPress_FarField);
fR_NearFeld = CalR(vForceEstimated_NearField, vPress_NearField);