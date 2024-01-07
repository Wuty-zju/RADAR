clear
clc
filename = './Hydroacoustic_Channel_Calculation/lib/Hydroacoustic_Channel_Calculation.arr';
Minimum_range=100  %（接收水听器的水平方向上接收范围最小值，m）----R 
Maximum_range=1000 %（接收水听器的水平方向上接收范围最大值，m）---RB 

[ amp1, delay, SrcAngle, RcvrAngle, NumTopBnc, NumBotBnc, narrmat, Pos ]... 
 = read_arrivals_asc(filename);

%%单位冲激响应
[m,n]=size(amp1);
amp = abs(amp1); %取模  
x = delay(m,:); %获取第50个接收机的时延和幅值
y = amp(m,:);


figure(1)
stem(x,y)
grid on
xlabel('相对时延/s')
ylabel('幅度')
title('单位冲激响应')




%%归一化冲激响应
Amp_Delay = [x;y];
Amp_Delay(:,all(Amp_Delay==0,1))=[]; %去掉0值
Amp_Delay=sortrows(Amp_Delay',1);  %按照时延从小到大排序
normDelay = Amp_Delay(:,1)-Amp_Delay(1,1);%归一化时延
normAmp = Amp_Delay(:,2)/Amp_Delay(1,2);%归一化幅度
figure(2)
stem(normDelay,normAmp,'^')
grid on
xlabel('相对时延/s')
ylabel('归一化幅度')
title('归一化冲激响应')

figure(3)
mum=1:m;
ReRange = Minimum_range+(Maximum_range-Minimum_range)/m*mum;
for i=1:min(narrmat)
plot(delay(:,i),ReRange,'o')
hold on
end
hold off
grid on
colorbar
xlabel('时延(sec)')
ylabel('Range(m)')
title(filename)