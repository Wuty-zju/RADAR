% 16QAM的调制与解调示例程序。
% 程序输出了上述过程中的图形，并且在控制台中输出了相关的信息。
clc;
clear all;
close all;



%==============================
%定义待仿真序列的长度 N
global N
N=10000;
% 首先产生随机二进制序列
source=randsrc(1,N,[1,0]);
%画出序列波形
figure(1);
stairs(source);
xlim([0,40]);
ylim([-0.5,1.5]);
title('随机二进制序列');



%==============================
%对产生的二进制序列进行QAM调制
%1.串并转换将原二进制序列转换成两路信号 I路：第1,3,5,7...元素 Q路：第2,4,6,8...元素
N=length(source);
a=1:2:N;
source1=source(a);%I路
source2=source(a+1);%Q路

%画出串并变换后序列波形
figure(2);
plot_2way_IQ(source1,source2);
title('串并变换后I路、Q路符号序列');


%2.分别对两路信号进行2/4电平变换
a=1:2:N/2;
temp1=source1(a);
temp2=source1(a+1);
y11=temp1*2+temp2;%I路 用十进制表示二进制
temp1=source2(a);
temp2=source2(a+1);
y22=temp1*2+temp2;%Q路 用十进制表示二进制

a=1:N/4;
source1=(y11*2-1-4)*1.*cos(2*pi*a);
source2=(y22*2-1-4)*1.*cos(2*pi*a);


%格雷码映射
source1(y11==0)=-3;  
source1(y11==1)=-1;
source1(y11==3)=1;
source1(y11==2)=3;%I路
source2(y22==0)=-3;
source2(y22==1)=-1;
source2(y22==3)=1;
source2(y22==2)=3;%Q路

% 画出序列波形
figure(3);
plot_2way_stair(source1,source2);
title('16QAM符号序列'); 

%画出星座图
figure(4);
plot_astrology(source1,source2);
title('16QAM星座图');

%画出频域图
figure(5);
 plot_2way_dtft(source1,source2);
title('16QAM符号频域图');



%===============================
%两路信号source1、source2进行插值，插值的比例为8
sig_insert1=zeros(1,8*length(source1));
a=1:8:length(sig_insert1);
sig_insert1(a)=source1;

sig_insert2=zeros(1,8*length(source2));
a=1:8:length(sig_insert2);
sig_insert2(a)=source2;

%画出两路信号的波形图
figure(6);
plot_2way(sig_insert1,sig_insert2,length(sig_insert1),0.5);
title('插值后I、Q两路信号的波形图');

%画出频域图
figure(7);
plot_2way_dtft(sig_insert1,sig_insert2);
title('插值16QAM符号频域图');



%===============================
%通过低通滤波器 
[sig_rcos1,sig_rcos2]=rise_cos(sig_insert1,sig_insert2,0.25,2);

%画出两路信号的波形图
figure(8);
plot_2way(sig_rcos1,sig_rcos2,length(sig_rcos1)/4,0.5);
title('通过低通滤波器后两路信号波形图');

%画出频域图
figure(9);
plot_2way_dtft(sig_rcos1',sig_rcos2');
title('通过低通滤波器后频域图');



%===============================
%将基带信号调制到高频上
f=0.25; %输入信号的频率
hf=2.5; %载波的频率

%创建两个中间变量，用于存储插值后的输入信号
yo1=zeros(1,length(sig_rcos1)*hf/f*10);
yo2=zeros(1,length(sig_rcos2)*hf/f*10);
n=1:length(yo1);

%对输入信号分别进行插值，相邻的两个点之间加入9个点，且这9个点的值同第0个点的值相同  
yo1(n)=sig_rcos1(floor((n-1)/(hf/f*10))+1);
yo2(n)=sig_rcos2(floor((n-1)/(hf/f*10))+1);

%生成输出输出信号的时间向量
t=(1:length(yo1))/hf*f/10;

%生成载波调制信号 得到sig_modulate
sig_modulate=yo1.*cos(2*pi*hf*t)-yo2.*sin(2*pi*hf*t);

%画出基带信号调制到高频之后的波形图
figure(10);
plot(t,sig_modulate);
xlim([0,800]);
title('基带信号调制到高频之后的波形图');



%===============================
%加入高斯白噪声
%设信噪比
snr=10;

%符号信噪比
snr1=snr+10*log10(4);

%所有信号的平均功率
%var()方差函数
ss=var(sig_rcos1+j*sig_rcos2,1);

%加入高斯白噪声
y=awgn([sig_rcos1+j*sig_rcos2],snr1+10*log10(ss/10),'measured');
%合起来的信号分为实部和虚部，实部为I路，虚部为Q路，再整体加高斯
x1=real(y);%对得到的信号，取实部为x1
x2=imag(y);%虚部为x2

%   ' 转置矩阵 确保第一个矩阵中的列数与第二个矩阵中的行数匹配
sig_noise1=x1';
sig_noise2=x2';

%画出I路和Q路加噪声后的波形图
figure(11);
plot_2way(sig_noise1,sig_noise2,length(sig_noise1)/4,0.5);
title('加入高斯白噪声之后的波形图');

%画出频域图
figure(12);
plot_2way_dtft(sig_noise1,sig_noise2);
title('加入高斯白噪声之后频域图');



%===============================
%经过匹配滤波器
[sig_match1,sig_match2]=rise_cos(sig_noise1,sig_noise2,0.25,2);

%画出经过匹配滤波器之后的波形图
figure(13);
plot_2way(sig_match1,sig_match2,length(sig_match1)/4,0.5);
title('经过匹配滤波器之后的波形图');

%画出频域图
figure(14);
plot_2way_dtft(sig_match1',sig_match2');
title('经过匹配滤波器之后DTFT频域图');



%===============================
%抽样
sig_pick1=sig_match1(8*3*2+1:8:(length(sig_match1)-8*3*2));
sig_pick2=sig_match2(8*3*2+1:8:(length(sig_match1)-8*3*2));

%画出星座图
figure(15);
plot_astrology(sig_pick1,sig_pick2);
title('接收的16QAM符号星座图');

%画出序列波形
figure(16);
plot_2way_stair(sig_pick1,sig_pick2);
title('接收的16QAM符号序列');

%画出频域图
figure(17);
plot_2way_dtft(sig_pick1',sig_pick2');
title('接收的QAM符号序列频域图');



%===============================
%QAM解调
%1.判决
%对x1路信号进行判决
xx1(sig_pick1>=2)=3;
xx1((sig_pick1<2)&(sig_pick1>=0))=1;
xx1((sig_pick1>=-2)&(sig_pick1<0))=-1;
xx1(sig_pick1<-2)=-3;
%对x2路信号进行判决
xx2(sig_pick2>=2)=3;
xx2((sig_pick2<2)&(sig_pick2>=0))=1;
xx2((sig_pick2>=-2)&(sig_pick2<0))=-1;
xx2(sig_pick2<-2)=-3;

%画出判决后16QAM符号序列
figure(18);
plot_2way_stair(xx1,xx2);
title('判决后16QAM符号序列'); 


%2.逆格雷码映射
%将x1路信号按格雷码映射规则还原成0、1信号
temp1=zeros(1,length(xx1)*2); %创建全0矩阵
temp1(find(xx1==-1)*2)=1;   %矩阵第二列置一
temp1(find(xx1==1)*2-1)=1;  %矩阵第一列置一
temp1(find(xx1==1)*2)=1;
temp1(find(xx1==3)*2-1)=1;
%将x2路信号按格雷码映射规则还原成0、1信号
temp2=zeros(1,length(xx2)*2);
temp2(find(xx2==-1)*2)=1;
temp2(find(xx2==1)*2-1)=1;
temp2(find(xx2==1)*2)=1;
temp2(find(xx2==3)*2-1)=1;

%画出4/2电平变换后I路、Q路符号序列
figure(19);
plot_2way_IQ(temp1,temp2);
title('4/2电平变换后I路、Q路符号序列');


%3.并串转换：将两路0、1信号合成一路
signal=zeros(1,length(temp1)*2);
signal(1:2:length(signal))=temp1; %奇数位为I路
signal(2:2:length(signal))=temp2; %偶数位为Q路

%画出接收端恢复的二进制序列
figure(20);
stairs(signal);
xlim([0,40]);
ylim([-0.5,1.5]);
title('接收端恢复的二进制序列');



%===============================
%误码率计算
[err_number,Pe] = biterr(source,signal);
fprintf('误码数以及误码率：\n');
fprintf('%d,%f;\n',err_number,Pe);
hold on

