% MUSIC_simulation.m
clc;
clear;

% 初始化参数
f0 = 1e10; % 信号频率为 X 波段 10 GHz
fs = 3 * f0; % 采样频率
N = 1000; % 快拍数
c = 3e8; % 光速
lamda = c / f0; % 求波长
d = lamda / 2; % 阵元间隔
M = 16; % 阵元数目
theta = [-10; 10]; % 方向来向角
theta_p = -90:0.05:90; % 方向角度扫描范围
atheta = exp(-j * 2 * pi * d * sin(theta / 180 * pi) * (0:M-1) / lamda); % 空域导向矢量

% 构建信号
s1 = sin(2 * pi * f0 * (0:1/fs:(N-1)/fs));
s2 = cos(2 * pi * f0 * (0:1/fs:(N-1)/fs));
S = [s1; s2];

% 信号模型
X = atheta' * S;
X = awgn(X, 10); % 添加白高斯噪声，SNR=10dB
Rhat = X * X' / N; % 协方差矩阵估计

% 特征值分解
[sigma, lamdaM] = eig(Rhat);
UN = sigma(:, 1:M-2);

% MUSIC 法
for i = 1:length(theta_p)
    atheta_p = exp(-j * 2 * pi * d * sin(theta_p(i) / 180 * pi) * (0:M-1) / lamda);
    p3(i) = abs(1 / (atheta_p * UN * UN' * atheta_p'));
end
P3 = 10 * log10(p3 / max(p3));

% 绘制图形
figure();
plot(theta_p, P3, 'r', 'linewidth', 1);
title('多信号分类 MUSIC');
xlabel('方向角/（\circ）');
ylabel('空间谱/dB');
grid on;
