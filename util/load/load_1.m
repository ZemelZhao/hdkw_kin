function emg = load_1(subject, session, sig_type)
    s_num = num2str(subject);

    if subject < 10
        s_num = ['0' s_num];
    end

    s_session = num2str(session);

    file_dir_path = ['data/exp_01/subject_' s_num  '/'];

    file_name = ['hdkw_kin_exp01_subj' s_num '_' s_session];
    
    if sig_type == 0
        file_tail = '_emg0';
    else
        file_tail = '_emg1';
    end

    emg = rdsamp([file_dir_path file_name file_tail]);
    emg = round(emg');
    emg = emg * 0.195;
end

