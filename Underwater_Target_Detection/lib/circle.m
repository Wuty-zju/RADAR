clc; close all; clear;
%% ��ȡ����
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
    temp = downsample( r_temp, arr_num, n-1 ).'; %������1��������ĵ�arr_num������,��һ������Ϊ��һ���������ƫ��n-1�����ݺ��
    data(:,n) = temp(:); %��n����Ԫ�Ľ�������        
end

%% FFT�����γ�
M = 16;%��Ԫ��Ŀ
r=0.75; %ˮƽԲ�뾶
h=1.5; %��ֱ�׾�1.5m
f=3100;
c=1500;
lambda=c/f;
deta = [0:M-1]*360/M;%��ʱ�벼��
x=roundn(r*cosd(deta),-2);
y=roundn(r*sind(deta),-2);
z=zeros(1,16);

%% �����ź�
S=fft(data(0.544e5:1.549e5,:),fs);% fft֮������[0,fs]
xs=S.';
figure(3)
% t=[0:length(x)]./fs-fs./2;
t=-fs/2:fs/2-1;
plot(t,fftshift(abs(xs(5,:)))); % fftshift����Ƶ�����ƶ�����������
ss=xs(:,f+1); %ȡ��3.1kHz��������

ks=100;
xx=-0.8:1/ks:0.8;
yy=-0.8:1/ks:0.8;
zz=-0.8:1/ks:0.8;
s=zeros(length(xx),length(yy),length(zz));

for i=1:M   %���źŷ�����ά����
    s(find(abs(xx-x(i))<0.001),find(abs(yy-y(i))<0.001),find(abs(zz-z(i))<0.001))=ss(i);
    a1=find(abs(xx-x(i))<0.001);
    a2=find(abs(yy-y(i))<0.001);
    a3=find(abs(zz-z(i))<0.001);
end

%���յ����ź�����ά����Ҷ�任
n_fft=600;
s_fft=fftn(s,[n_fft,n_fft,n_fft]);
s_fft=fftshift(s_fft);
r1=n_fft/ks/lambda;
theta_r=-180:0.5:180;
phi_r=0:0.5:180;
xr=round(r1*cosd(theta_r')*sind(phi_r));
yr=round(r1*sind(theta_r')*sind(phi_r));
zr=repmat(round(r1*cosd(phi_r)),length(theta_r),1);% �з���Ϊԭ�����length(theta_r)�����з���Ϊԭ�����1��
plot3(xr,yr,zr)
for i=1:length(theta_r)
    for j=1:length(phi_r)
        R_steer_est(i,j)=abs(s_fft(xr(i,j)+n_fft/2+1,yr(i,j)+n_fft/2+1,zr(i,j)+n_fft/2+1)); %ȡ��ά����Ҷ�任���������
    end
end

[az,el]=meshgrid(phi_r,theta_r);
% [xx,y,z]=sph2cart(az,el,R_steer_est);
mesh(el,az,20*log10(R_steer_est/max(max(R_steer_est))));
xlabel('��λ��')
ylabel('������')
zlabel('����')
title('FFT�����γɽ��')
% surf(az,el,20*log10(R_steer_est/max(max(R_steer__est))));
colormap('jet'); 
colorbar;
zlim([-50,0])
caxis([-50 0])
shading interp