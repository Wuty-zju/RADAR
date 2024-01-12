clc;
clear;
close all;

%%
fs=100000; % ������
T=0.0001; % ����
num_d=20; % ��Ԫ��
f1=8000; % Ƶ��1
f2=10000; % Ƶ��2

%%
s_d=randn(num_d,1)>0; % �����������
s=zeros(1,fs*T*num_d);
s0=zeros(1,fs*T); % ��������s
for ii=1:num_d
    s((ii-1)*fs*T+1:ii*fs*T)=s0+s_d(ii);
end

t=1/fs:1/fs:T*num_d; % ʱ������
y=cos(2*pi*f1.*t+2*pi*(f2-f1).*t.*s); % �����ź�

% ʱ����
figure(1);
plot(t*1000,y);
xlabel('ʱ��/ms');
ylabel('����');
title('FSK�ź�ʱ����');

%% Ƶ��
figure(2);
n=length(y);
r=fft(y)/n;r=fftshift(r);
f=linspace(-fs/2,fs/2,n);

plot(f/1000,abs(r));
xlabel('Ƶ��/kHz');
title('FSK�ź�Ƶ��');

%% ����������
figure(3);
u=exp(i*2*pi*(f2-f1).*t.*s);
plot(t*1000,real(u));
hold on;
plot(t*1000,imag(u));
legend('ʵ��','�鲿');
title('FSK�źŵĻ���������');
xlabel('ʱ��/ms');
ylabel('����');