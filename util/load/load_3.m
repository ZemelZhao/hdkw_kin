function [emg, glove] = load_3(subject, session)
    s_num = num2str(subject);

    if subject < 10
        s_num = ['0' s_num];
    end

    s_session = num2str(session);

    file_dir_path = ['data/exp_03/subject_' s_num  '/'];

    file_name = ['hdkw_kin_exp03_subj' s_num '_' s_session];
    
    file_tail_emg = '_emg';
    file_tail_glove = '_glove';

    emg = rdsamp([file_dir_path file_name file_tail_emg]);
    glove = rdsamp([file_dir_path file_name file_tail_glove]);
    emg = round(emg');
    glove = round(glove');
    
    emg = emg * 0.195;


end

