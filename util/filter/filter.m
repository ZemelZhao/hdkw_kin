function res = filter(data)
    fs = 2000;
    Q = 30;

    pass_low = 15;
    pass_high = 500;
    n = 4;

    [fpb, fpa] = butter(n, [2*pass_low/fs, 2*pass_high/fs], 'bandpass');
    [fnb1, fna1] = iirnotch(2*50/fs, 2*50/(fs*Q));
    [fnb2, fna2] = iirnotch(2*150/fs, 2*150/(fs*Q));
    [fnb3, fna3] = iirnotch(2*250/fs, 2*250/(fs*Q));
    [fnb4, fna4] = iirnotch(2*350/fs, 2*350/(fs*Q));
    [fnb5, fna5] = iirnotch(2*450/fs, 2*450/(fs*Q));

    [cLen, ~] = size(data);

    for c = 1 : cLen
        data(c, :) = filtfilt(fpb, fpa, data(c, :));
        data(c, :) = filtfilt(fnb1, fna1, data(c, :));
        data(c, :) = filtfilt(fnb2, fna2, data(c, :));
        data(c, :) = filtfilt(fnb3, fna3, data(c, :));
        data(c, :) = filtfilt(fnb4, fna4, data(c, :));
        data(c, :) = filtfilt(fnb5, fna5, data(c, :));
    end

    res = data;

end