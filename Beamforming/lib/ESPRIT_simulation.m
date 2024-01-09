%设置参数
f0=1e10;%信号频率
fs=3*f0;%采样频率
N=1000;%快拍数
c=3e8;%光速
lamda=c/f0;%求波长lamda
d=lamda/2;%阵元间隔
M=16;%阵元数目
delta=d;
theta=[-10;10];%方向来向角theta=30度
Atheta=(exp(-j*2*pi*d*sin(theta/180*pi)*(0:M-1)/lamda))';%A(theta)为空域导向矩阵，这里为M*P矩阵

%假设发射信号为一个sin(t)函数，对其采样1000次，得到S
s1=sin(2*pi*f0*(0:1/fs:(N-1)/fs));
s2=cos(2*pi*f0*(0:1/fs:(N-1)/fs));
S=[s1;s2];%S为2*N矩阵

%将接收信号分为两个子阵并将其合并
x=Atheta*S;%采样信号为x=a(theta)*singal+n(t)，这里为M*N矩阵
x=awgn(x,20);%添加白高斯噪声，snr=10
X1=x(1:M-1,:);
X2=x(2:M,:);%分成两个M-1*p的矩阵
X=[X1;X2];%X为2M-2*N矩阵

%计算Rhat并得到酉矩阵Us1和Us2
Rhat=X*X'/N;%R^=X*X'/N
[sigma,lamdaM]=eig(Rhat);%求Rhat的特征值和特征向量，sigma为从小到大排列的特征向量，lamdaM为M个特征值
Us=sigma(:,2*(M-1)-1:2*(M-1));%两个信源，后两个特征向量为信源特征向量，前十四个为噪声特征向量，将信源特征向量提取出来
Us1=Us(1:(M-1),:);
Us2=Us(M:2*(M-1),:);%拆分矩阵为两个M*P

%计算来向角
Psai=(Us1'*Us1)^-1*Us1'*Us2;
[~,lamdaphi]=eig(Psai);
phi_p=diag(lamdaphi);
theta_p=asind(phase(phi_p)*lamda/(2*pi*abs(delta)));

%使用stem绘制散点图
y=[1 1];
stem(theta_p,y,'linewidth',1);
xlim([-100,100]);
ylim([0,2]);
title('旋转不变子空间 ESPRIT');
xlabel('方向角/（\circ）');
ylabel('空间谱/dB');
grid on;


