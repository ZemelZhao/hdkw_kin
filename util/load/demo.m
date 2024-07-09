close all;
clear;

% dependency: ikarosilva/wfdb-app-toolbox

% demo for Experiment 01 (Subject 1-21, Session 1-6, SigType 0&1)
emg_01 = load_1(1, 1, 0);

% demo for Experiment 02 (Subject 1-21, Session 1-6, MVC 20&40)
[emg_02, press_02] = load_2(1, 1, 20);

% demo for Experiment 03 (Subject 1-10, Session 1-6)
[emg_03, glove_03] = load_3(1, 1);