clc; close all; clear;
%% 读取数据
fclose('all');
fs=100000;
arr_num=16;
sample=1000;
fp=fopen('circle2.dat','r');
raw=fread(fp,'double');
N_raw = length( raw );
r_temp = reshape( raw, sample, N_raw/sample );
r_temp = r_temp.';
data = zeros( N_raw/arr_num, arr_num );
for n = 1:arr_num
    temp = downsample( r_temp, arr_num, n-1 ).'; %保留第1个样本后的第arr_num个样本,第一个样本为第一个数据向后偏移n-1个数据后的
    data(:,n) = temp(:); %第n个阵元的接收数据        
end

%% FFT波束形成
M = 16;%阵元数目
r=0.75; %水平圆半径
h=1.5; %垂直孔径1.5m
f=3100;
c=1500;
lambda=c/f;
deta = [0:M-1]*360/M;%逆时针布阵
x=roundn(r*cosd(deta),-2);
y=roundn(r*sind(deta),-2);
z=zeros(1,16);

%% 输入信号
S=fft(data(0.544e5:1.549e5,:),fs);% fft之后结果在[0,fs]
xs=S.';
figure(3)
% t=[0:length(x)]./fs-fs./2;
t=-fs/2:fs/2-1;
plot(t,fftshift(abs(xs(5,:)))); % fftshift将零频分量移动到数组中心
ss=xs(:,f+1); %取出3.1kHz处的数据

ks=100;
xx=-0.8:1/ks:0.8;
yy=-0.8:1/ks:0.8;
zz=-0.8:1/ks:0.8;
s=zeros(length(xx),length(yy),length(zz));

for i=1:M   %将信号放入三维矩阵
    s(find(abs(xx-x(i))<0.001),find(abs(yy-y(i))<0.001),find(abs(zz-z(i))<0.001))=ss(i);
    a1=find(abs(xx-x(i))<0.001);
    a2=find(abs(yy-y(i))<0.001);
    a3=find(abs(zz-z(i))<0.001);
end

%接收到的信号做三维傅里叶变换
n_fft=600;
s_fft=fftn(s,[n_fft,n_fft,n_fft]);
s_fft=fftshift(s_fft);
r1=n_fft/ks/lambda;
theta_r=-180:0.5:180;
phi_r=0:0.5:180;
xr=round(r1*cosd(theta_r')*sind(phi_r));
yr=round(r1*sind(theta_r')*sind(phi_r));
zr=repmat(round(r1*cosd(phi_r)),length(theta_r),1);% 行方向为原矩阵的length(theta_r)倍，列方向为原矩阵的1倍
plot3(xr,yr,zr)
for i=1:length(theta_r)
    for j=1:length(phi_r)
        R_steer_est(i,j)=abs(s_fft(xr(i,j)+n_fft/2+1,yr(i,j)+n_fft/2+1,zr(i,j)+n_fft/2+1)); %取二维傅里叶变换结果的球面
    end
end

[az,el]=meshgrid(phi_r,theta_r);
% [xx,y,z]=sph2cart(az,el,R_steer_est);
mesh(el,az,20*log10(R_steer_est/max(max(R_steer_est))));
xlabel('方位角')
ylabel('俯仰角')
zlabel('幅度')
title('FFT波束形成结果')
% surf(az,el,20*log10(R_steer_est/max(max(R_steer__est))));
colormap('jet'); 
colorbar;
zlim([-50,0])
caxis([-50 0])
shading interp