clc;close all;clear all;

af_sp(1e-6,64);
%%tp=1e-6，n=64

af_gauss(1e-6,4e-6,64);
%%sigma=1e-6，tp=4e-6，n=64

af_lfm(4e6,2e-6,64);
%%B=4e6,tp=2e-6,n=64

af_lfm(4e5,2e-6,64);
%%B=4e5,tp=2e-6,n=64