close all;
clear;

for num = 1 : 21

    s_num = num2str(num);
    if num < 10
        s_num = ['0' s_num];
    end

    dir_path = ['H:/zmz/sci_data/data/data/gesture/subject_' s_num '/'];
    glove_name1 = ['hdkw_kin_exp01_subj' s_num '_1.mat'];
    glove_name2 = ['hdkw_kin_exp01_subj' s_num '_2.mat'];
    glove_name3 = ['hdkw_kin_exp01_subj' s_num '_3.mat'];
    glove_name4 = ['hdkw_kin_exp01_subj' s_num '_4.mat'];
    glove_name5 = ['hdkw_kin_exp01_subj' s_num '_5.mat'];
    glove_name6 = ['hdkw_kin_exp01_subj' s_num '_6.mat'];

    data = load([dir_path glove_name1]);
    glove_data1 = data.data.emg_gesture;
    wrist_data1 = data.data.emg_wrist;
    glove_data1 = glove_data1([1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 269 281 293 305 317 329 341 353 365 377 389 401 413 425 437], :);
    wrist_data1 = wrist_data1([1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 269 281 293 305 317 329 341 353 365 377 389 401 413 425 437], :);

    data = load([dir_path glove_name2]);
    glove_data2 = data.data.emg_gesture;
    wrist_data2 = data.data.emg_wrist;
    glove_data2 = glove_data2([1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 269 281 293 305 317 329 341 353 365 377 389 401 413 425 437], :);
    wrist_data2 = wrist_data2([1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 269 281 293 305 317 329 341 353 365 377 389 401 413 425 437], :);

    data = load([dir_path glove_name3]);
    glove_data3 = data.data.emg_gesture;
    wrist_data3 = data.data.emg_wrist;
    glove_data3 = glove_data3([1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 269 281 293 305 317 329 341 353 365 377 389 401 413 425 437], :);
    wrist_data3 = wrist_data3([1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 269 281 293 305 317 329 341 353 365 377 389 401 413 425 437], :);

    data = load([dir_path glove_name4]);
    glove_data4 = data.data.emg_gesture;
    wrist_data4 = data.data.emg_wrist;
    glove_data4 = glove_data4([1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 269 281 293 305 317 329 341 353 365 377 389 401 413 425 437], :);
    wrist_data4 = wrist_data4([1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 269 281 293 305 317 329 341 353 365 377 389 401 413 425 437], :);

    data = load([dir_path glove_name5]);
    glove_data5 = data.data.emg_gesture;
    wrist_data5 = data.data.emg_wrist;
    glove_data5 = glove_data5([1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 269 281 293 305 317 329 341 353 365 377 389 401 413 425 437], :);
    wrist_data5 = wrist_data5([1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 269 281 293 305 317 329 341 353 365 377 389 401 413 425 437], :);

    data = load([dir_path glove_name6]);
    glove_data6 = data.data.emg_gesture;
    wrist_data6 = data.data.emg_wrist;
    glove_data6 = glove_data6([1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 269 281 293 305 317 329 341 353 365 377 389 401 413 425 437], :);
    wrist_data6 = wrist_data6([1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 257 269 281 293 305 317 329 341 353 365 377 389 401 413 425 437], :);

    glove_data_filtered1 = gesture_filter(glove_data1);
    glove_data_filtered2 = gesture_filter(glove_data2);
    glove_data_filtered3 = gesture_filter(glove_data3);
    glove_data_filtered4 = gesture_filter(glove_data4);
    glove_data_filtered5 = gesture_filter(glove_data5);
    glove_data_filtered6 = gesture_filter(glove_data6);
    wrist_data_filtered1 = gesture_filter(wrist_data1);
    wrist_data_filtered2 = gesture_filter(wrist_data2);
    wrist_data_filtered3 = gesture_filter(wrist_data3);
    wrist_data_filtered4 = gesture_filter(wrist_data4);
    wrist_data_filtered5 = gesture_filter(wrist_data5);
    wrist_data_filtered6 = gesture_filter(wrist_data6);

    gesture_data1= [glove_data_filtered1 wrist_data_filtered1];
    gesture_data2= [glove_data_filtered2 wrist_data_filtered2];
    gesture_data3= [glove_data_filtered3 wrist_data_filtered3];
    gesture_data4= [glove_data_filtered4 wrist_data_filtered4];
    gesture_data5= [glove_data_filtered5 wrist_data_filtered5];
    gesture_data6= [glove_data_filtered6 wrist_data_filtered6];

    %%
    trial_num = 6;
    act_num = 21;
    trial_cache = cell(trial_num, act_num);
    fs = 2000;

    for i = 1 : trial_num
        if i == 1
            emg = gesture_data1';
        elseif i == 2
            emg = gesture_data2';
        elseif i == 3
            emg = gesture_data3';
        elseif i == 4
            emg = gesture_data4';
        elseif i == 5
            emg = gesture_data5';
        else
            emg = gesture_data6';
        end

        data1=emg(1:fs*187,:);
        data2=emg(1+fs*187:(187+75)*fs,:);
        act0_data = data1((5+14*1+10)*fs+1 : (5+14*1+13)*fs,:);
        act1_data = data1((5+14*0+5)*fs+1 : (5+14*0+8)*fs,:);
        act2_data = data1((5+14*1+5)*fs+1 : (5+14*1+8)*fs,:);
        act3_data = data1((5+14*2+5)*fs+1 : (5+14*2+8)*fs,:);
        act4_data = data1((5+14*3+5)*fs+1 : (5+14*3+8)*fs,:);
        act5_data = data1((5+14*4+5)*fs+1 : (5+14*4+8)*fs,:);
        act6_data = data1((5+14*5+5)*fs+1 : (5+14*5+8)*fs,:);
        act7_data = data1((5+14*6+5)*fs+1 : (5+14*6+8)*fs,:);
        act8_data = data1((5+14*7+5)*fs+1 : (5+14*7+8)*fs,:);
        act9_data = data1((5+14*8+5)*fs+1 : (5+14*8+8)*fs,:);
        act10_data = data1((5+14*9+5)*fs+1 : (5+14*9+8)*fs,:);
        act11_data = data1((5+14*10+5)*fs+1 : (5+14*10+8)*fs,:);
        act12_data = data1((5+14*11+5)*fs+1 : (5+14*11+8)*fs,:);
        act13_data = data1((5+14*12+5)*fs+1 : (5+14*12+8)*fs,:);
        act14_data = data2((5+10*0+1)*fs+1 : (5+10*0+4)*fs,:);
        act15_data = data2((5+10*1+1)*fs+1 : (5+10*1+4)*fs,:);
        act16_data = data2((5+10*2+1)*fs+1 : (5+10*2+4)*fs,:);
        act17_data = data2((5+10*3+1)*fs+1 : (5+10*3+4)*fs,:);
        act18_data = data2((5+10*4+1)*fs+1 : (5+10*4+4)*fs,:);
        act19_data = data2((5+10*5+1)*fs+1 : (5+10*5+4)*fs,:);
        act20_data = data2((5+10*6+1)*fs+1 : (5+10*6+4)*fs,:);

        trial_cache{i, 21} = act0_data;
        trial_cache{i, 1} = act1_data;
        trial_cache{i, 2} = act2_data;
        trial_cache{i, 3} = act3_data;
        trial_cache{i, 4} = act4_data;
        trial_cache{i, 5} = act5_data;
        trial_cache{i, 6} = act6_data;
        trial_cache{i, 7} = act7_data;
        trial_cache{i, 8} = act8_data;
        trial_cache{i, 9} = act9_data;
        trial_cache{i, 10} = act10_data;
        trial_cache{i, 11} = act11_data;
        trial_cache{i, 12} = act12_data;
        trial_cache{i, 13} = act13_data;
        trial_cache{i, 14} = act14_data;
        trial_cache{i, 15} = act15_data;
        trial_cache{i, 16} = act16_data;
        trial_cache{i, 17} = act17_data;
        trial_cache{i, 18} = act18_data;
        trial_cache{i, 19} = act19_data;
        trial_cache{i, 20} = act20_data;
    end

    %%
    fs = 2000;
    trial_num = 6;
    dataEmg = cell(trial_num, act_num);
    winlen = 0.2*fs;
    steplen = 0.1*fs;

    for i = 1 : trial_num
        for j = 1 : act_num
            sumemg = trial_cache{i, j};
            datalen = size(sumemg,1);
            winnum = round((datalen-winlen+steplen)/steplen);
            dataEmg{i, j} = divide(sumemg,winlen,winnum,steplen);
        end
    end

    res = zeros(3, 3);
    %%
    for feat_num = 1 : 3
        feature_cache = cell(trial_num, act_num);
        if feat_num == 1
            for i =1:trial_num
                for j = 1:act_num
                    feature_cache{i,j} = trial_feat(dataEmg{i,j}(:, 1:16, :));
                end
            end
        elseif feat_num == 2
            for i =1:trial_num
                for j = 1:act_num
                    feature_cache{i,j} = trial_feat(dataEmg{i,j}(:, 17:32, :));
                end
            end
        else
            for i =1:trial_num
                for j = 1:act_num
                    feature_cache{i,j} = trial_feat(dataEmg{i,j}(:, :, :));
                end
            end
        end

        featEmg = feature_cache;


        feature = featEmg;
        [trialnum, classnum] = size(feature);
        [winnum,~] = size(feature{1,1});
        crossnum=trialnum;%n重交叉验证,重数等于trial的个数
        feat=cell(trialnum,1);

        for t=1:crossnum
            Rand_trial=randperm(trialnum*winnum);
            feature1=cell(1,classnum);
            for i=1:classnum
                feature1{1,i}(:,:)=[feature{1,i};feature{2,i};feature{3,i};feature{4,i};feature{5,i};feature{6,i}];%交叉验证的次数等于trial的个数，届时可能需要在此修改
            end
            for k=1:classnum
                for i=1:trialnum
                    for j=1:winnum
                        feature{i,k}(j,:)=feature1{1,k}(Rand_trial(j+winnum*(i-1)),:);
                    end
                end
            end
            feat{t,1}=feature;
        end
        %分类
        testnum=trialnum;%测试次数等于交叉验证重数等于trial个数
        cly_rate=zeros(crossnum,testnum);%单次识别率
        confusion=cell(crossnum,testnum);%单次混淆矩阵
        for j=1:crossnum
            for i=1:testnum
                [cly_rate(j,i) confusion{j,i}] = lda_classify_1test(feat{j,1},i);%调用LDA分类器
            end
        end
        %求平均识别率及标准差
        cly_rate1=cly_rate(:);
        ave_rate=mean(cly_rate1);
        variance=std(cly_rate1);
        %求每类动作的识别率及标准差
        class_rate=zeros(1,classnum);
        for i=1:crossnum
            for j=1:crossnum
                for k=1:classnum
                    class_rate(k)=class_rate(k)+confusion{i,j}(k,k)/(crossnum*crossnum);
                    e((i-1)*crossnum+j,k)=confusion{i,j}(k,k);
                end
            end
        end
        for i=1:size(e,2)
            er(i)=std(e(:,i));
        end

        res(feat_num, 1) = ave_rate;

        %%
        feature_cache = cell(trial_num, act_num);
        for i =1:trial_num
            for j = 1:act_num
                feature_cache{i,j} = trial_feat(dataEmg{i,j});
            end
        end

        featEmg = feature_cache;

        %%
        feature = cell(6, 15);
        for i = 1 : 6
            for j = 1 : 14
                feature{i, j} = featEmg{i, j};
            end
            feature{i, 15} = featEmg{i, 21};
        end

        [trialnum, classnum] = size(feature);
        [winnum,~] = size(feature{1,1});
        crossnum=trialnum;%n重交叉验证,重数等于trial的个数
        feat=cell(trialnum,1);

        for t=1:crossnum
            Rand_trial=randperm(trialnum*winnum);
            feature1=cell(1,classnum);
            for i=1:classnum
                feature1{1,i}(:,:)=[feature{1,i};feature{2,i};feature{3,i};feature{4,i};feature{5,i};feature{6,i}];%交叉验证的次数等于trial的个数，届时可能需要在此修改
            end
            for k=1:classnum
                for i=1:trialnum
                    for j=1:winnum
                        feature{i,k}(j,:)=feature1{1,k}(Rand_trial(j+winnum*(i-1)),:);
                    end
                end
            end
            feat{t,1}=feature;
        end
        %分类
        testnum=trialnum;%测试次数等于交叉验证重数等于trial个数
        cly_rate=zeros(crossnum,testnum);%单次识别率
        confusion=cell(crossnum,testnum);%单次混淆矩阵
        for j=1:crossnum
            for i=1:testnum
                [cly_rate(j,i) confusion{j,i}] = lda_classify_1test(feat{j,1},i);%调用LDA分类器
            end
        end
        %求平均识别率及标准差
        cly_rate1=cly_rate(:);
        ave_rate=mean(cly_rate1);
        variance=std(cly_rate1);
        %求每类动作的识别率及标准差
        class_rate=zeros(1,classnum);
        for i=1:crossnum
            for j=1:crossnum
                for k=1:classnum
                    class_rate(k)=class_rate(k)+confusion{i,j}(k,k)/(crossnum*crossnum);
                    e((i-1)*crossnum+j,k)=confusion{i,j}(k,k);
                end
            end
        end
        for i=1:size(e,2)
            er(i)=std(e(:,i));
        end

        res(feat_num, 2) = ave_rate;

        %%
        feature = cell(6, 7);
        for i = 1 : 6
            for j = 1 : 6
                feature{i, j} = featEmg{i, j};
            end
            feature{i, 7} = featEmg{i, 21};
        end

        [trialnum, classnum] = size(feature);
        [winnum,~] = size(feature{1,1});
        crossnum=trialnum;%n重交叉验证,重数等于trial的个数
        feat=cell(trialnum,1);

        for t=1:crossnum
            Rand_trial=randperm(trialnum*winnum);
            feature1=cell(1,classnum);
            for i=1:classnum
                feature1{1,i}(:,:)=[feature{1,i};feature{2,i};feature{3,i};feature{4,i};feature{5,i};feature{6,i}];%交叉验证的次数等于trial的个数，届时可能需要在此修改
            end
            for k=1:classnum
                for i=1:trialnum
                    for j=1:winnum
                        feature{i,k}(j,:)=feature1{1,k}(Rand_trial(j+winnum*(i-1)),:);
                    end
                end
            end
            feat{t,1}=feature;
        end

        testnum=trialnum;%测试次数等于交叉验证重数等于trial个数
        cly_rate=zeros(crossnum,testnum);%单次识别率
        confusion=cell(crossnum,testnum);%单次混淆矩阵
        for j=1:crossnum
            for i=1:testnum
                [cly_rate(j,i) confusion{j,i}] = lda_classify_1test(feat{j,1},i);%调用LDA分类器
            end
        end
        cly_rate1=cly_rate(:);
        ave_rate=mean(cly_rate1);
        variance=std(cly_rate1);
        class_rate=zeros(1,classnum);
        for i=1:crossnum
            for j=1:crossnum
                for k=1:classnum
                    class_rate(k)=class_rate(k)+confusion{i,j}(k,k)/(crossnum*crossnum);
                    e((i-1)*crossnum+j,k)=confusion{i,j}(k,k);
                end
            end
        end
        for i=1:size(e,2)
            er(i)=std(e(:,i));
        end

        res(feat_num, 3) = ave_rate;
    end
    save(['res/res_rate_' s_num '.mat'], 'res');
end