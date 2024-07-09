% This code references the published toolbox of "Xinyu Jiang , Xiangyu Liu, Jiahao Fan, et al. Open access dataset, toolbox and benchmark processing results of high-density surface electromyogram recordings. IEEE Trans. Neural Syst. Rehabil. Eng., 2021, 29, 1035-46."
function ssc=CalSSC(emg,window_len,step_len,thresh, fs)

	window_sample=floor(window_len*fs);
	step_sample=floor(step_len*fs);
	[Nsample,Nchannel]=size(emg);

	fea_idx=0;
	for i=1:step_sample:(Nsample-window_sample+1)
	fea_idx=fea_idx+1;
		for j=1:Nchannel
			emg_window=emg(i:i+window_sample-1,j);
			ssc(fea_idx,j)=my_ssc(emg_window,thresh);
		end
	end
end


function ssc_value=my_ssc(sig,thresh)

	N=length(sig);

	ssc_value=0;
	for i=2:N-1
		if( ((sig(i)-sig(i-1))*(sig(i)-sig(i+1))>0) && ( (abs(sig(i+1)-sig(i))>thresh) || (abs(sig(i-1)-sig(i))>thresh) ) )
			ssc_value=ssc_value+1;
		end
	end
end