% main.m
clc;
clear;
close all;

% 执行每个仿真脚本
run('CBF_simulation.m');

run('MVDR_simulation.m');

run('MUSIC_simulation.m');

run('ESPRIT_simulation.m');
