close all;
clear;

dir = 'H:/zmz/sci_data/subject_01/res/';

res = zeros(3, 21*6);
for num = 1 : 21

    s_num = num2str(num);
    if num < 10
        s_num = ['0' s_num];
    end

    file_path = ['res_rate_' s_num '.mat'];

    data = load([dir file_path]);
    data = data.res;

    data_wrist_20 = data(1, 1);
    data_wrist_14 = data(1, 2);
    data_wrist_6 = data(1, 3);
    data_fore_20 = data(2, 1);
    data_fore_14 = data(2, 2);
    data_fore_6 = data(2, 3);
    data_all_20 = data(3, 1);
    data_all_14 = data(3, 2);
    data_all_6 = data(3, 3);

    res(1, num+21*0) = data_wrist_14;
    res(2, num+21*0) = data_wrist_6;
    res(3, num+21*0) = data_wrist_20;
    res(1, num+21*1) = data_fore_14;
    res(2, num+21*1) = data_fore_6;
    res(3, num+21*1) = data_fore_20;
    res(1, num+21*2) = data_all_14;
    res(2, num+21*2) = data_all_6;
    res(3, num+21*2) = data_all_20;

end
