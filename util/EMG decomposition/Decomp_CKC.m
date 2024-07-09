function vResult_CKC = Decomp_CKC(vEMG)

% Parameters           
vPara.fMeanFRThreshold_MUST = 35;    % Threshold of average firing rate, which is used to judge whether the decoded MUST is valid
vPara.fPNRThreshold_MUST = 20;       % Threshold of pulse-to-noise ratio, which is used to judge whether the decoded MUST is valid
vPara_CKC.extendingFactor = 10;      % Extending factor of EMG data
vPara_CKC.iterationNumW = 100;       % Number of iterations for calculating separation parameter (W)
vPara_CKC.iterationNumMU = 100;      % Number of iterations for decoding MUs
vPara_CKC.fSamp = 2000;              % Sampling frequency of EMG data (Hz)
vPara.vPara_CKC = vPara_CKC;

% Decomposition based on gCKC
% The codes of the following function "CKC" reference "A. Holobar et al. Gradient convolution kernel compensation applied to surface electromyograms. Proc. Int. Conf. Independent Compon. Anal. Signal Separation, Springer, 2007, 617–24".
% The variable "vResult_CKC" was desinged to contain following data: (1) Decoded MUST of each MU, (2) Separation parameter W of each MU, (3) Separation parameter ctx of each MU, (4) Pulse-to-noise ratio of each MUST, (5) Clustering centroids of each MU.
vResult_CKC = CKC(vEMG, vPara); 

end