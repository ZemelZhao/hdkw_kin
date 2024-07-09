% This code references the published toolbox of "Xinyu Jiang , Xiangyu Liu, Jiahao Fan, et al. Open access dataset, toolbox and benchmark processing results of high-density surface electromyogram recordings. IEEE Trans. Neural Syst. Rehabil. Eng., 2021, 29, 1035-46."
function zc = CalZC(emg,window_len,step_len,thresh, fs)

	window_sample=floor(window_len*fs);
	step_sample=floor(step_len*fs);
	[Nsample,Nchannel]=size(emg);

	fea_idx=0;
	for i=1:step_sample:(Nsample-window_sample+1)
		fea_idx=fea_idx+1;
		for j=1:Nchannel
			emg_window=emg(i:i+window_sample-1,j);
			zc(fea_idx,j)=my_zc(emg_window,thresh);
		end
	end
end


function zc_value=my_zc(sig,thresh)

	N=length(sig);

	zc_value=0;
	for i=1:N-1
		if( (abs(sig(i+1)-sig(i))>thresh) && (sig(i)*sig(i+1)<0) )
			zc_value=zc_value+1;
		end
	end
end