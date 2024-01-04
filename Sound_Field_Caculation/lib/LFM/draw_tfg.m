
close all
%% LFM信号生成
T=30;                                                                      %总时长
t1=1;                                                                       %start time of the chirp signal (secs)
tau=1;                                                                      %chirp信号持续时间
f1=1750;                                                                    %start frequency of the chirp
B=200;                                                                      %带宽
fs=8e3;
LFM_length = tau*fs;
[LFM_sig, LFM_taxis] = dl_genLFM(T, fs, t1, tau, f1,B, 'tukey');    %LFM信号生成
y=LFM_sig;
spectrogram(y,kaiser(128,18),120,128,1E3,'yaxis');   