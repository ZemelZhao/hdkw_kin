function [emg, press] = load_2(subject, session, mvc)
    s_num = num2str(subject);

    if subject < 10
        s_num = ['0' s_num];
    end

    s_session = num2str(session);

    file_dir_path = ['data/exp_02/subject_' s_num  '/'];

    file_name = ['hdkw_kin_exp02_subj' s_num '_' s_session];
    
    if mvc == 20
        file_tail_emg = '_emg0';
        file_tail_press = '_press0';
    else
        file_tail_emg = '_emg1';
        file_tail_press = '_press1';
    end

    emg = rdsamp([file_dir_path file_name file_tail_emg]);
    press = rdsamp([file_dir_path file_name file_tail_press]);
    emg = round(emg');
    press = round(press');
    
    emg = emg * 0.195;


end

