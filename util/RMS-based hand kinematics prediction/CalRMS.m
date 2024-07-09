% This code references the published toolbox of "Xinyu Jiang , Xiangyu Liu, Jiahao Fan, et al. Open access dataset, toolbox and benchmark processing results of high-density surface electromyogram recordings. IEEE Trans. Neural Syst. Rehabil. Eng., 2021, 29, 1035-46."
function rms = CalRMS(emg,window_len,step_len,fs)

window_sample=floor(window_len*fs);
step_sample=floor(step_len*fs);
[Nsample,Nchannel]=size(emg);

fea_idx=0;
for i=1:step_sample:(Nsample-window_sample+1)
    fea_idx=fea_idx+1;
    for j=1:Nchannel
        emg_window=emg(i:i+window_sample-1,j);
        rms(fea_idx,j)=sqrt(mean(emg_window.^2));
    end
end