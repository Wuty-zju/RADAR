clc;
clear;
close all;

%%
fs=100000; % 采样率
T=0.0001; % 脉宽
num_d=20; % 码元数
f1=8000; % 频率1
f2=10000; % 频率2

%%
s_d=randn(num_d,1)>0; % 随机数字序列
s=zeros(1,fs*T*num_d);
s0=zeros(1,fs*T); % 用于生成s
for ii=1:num_d
    s((ii-1)*fs*T+1:ii*fs*T)=s0+s_d(ii);
end

t=1/fs:1/fs:T*num_d; % 时间序列
y=cos(2*pi*f1.*t+2*pi*(f2-f1).*t.*s); % 生成信号

% 时域波形
figure(1);
plot(t*1000,y);
xlabel('时间/ms');
ylabel('幅度');
title('FSK信号时域波形');

%% 频谱
figure(2);
n=length(y);
r=fft(y)/n;r=fftshift(r);
f=linspace(-fs/2,fs/2,n);

plot(f/1000,abs(r));
xlabel('频率/kHz');
title('FSK信号频谱');

%% 基带复包络
figure(3);
u=exp(i*2*pi*(f2-f1).*t.*s);
plot(t*1000,real(u));
hold on;
plot(t*1000,imag(u));
legend('实部','虚部');
title('FSK信号的基带复包络');
xlabel('时间/ms');
ylabel('幅度');