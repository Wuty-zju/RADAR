clear all
N=100000;
X=randsrc(1,N,[0,1]);
 
%获得水声信道冲击响应
filename = './Hydroacoustic_Channel_Calculation/lib/Hydroacoustic_Channel_Calculation.arr'; 
[ amp1, delay1, SrcAngle, RcvrAngle, NumTopBnc, NumBotBnc, narrmat, Pos ]... 
 = read_arrivals_asc(filename);

%%单位冲激响应
[m,n]=size(amp1);
amp=abs(amp1(m,:));%取模 
delay=delay1(m,:);
%%归一化冲激响应
Amp_Delay=[delay;amp];
Amp_Delay(:,all(Amp_Delay==0,1))=[];%去掉0值
Amp_Delay=sortrows(Amp_Delay',1);%按照时延从小到大排序
normDelay=Amp_Delay(:,1)-Amp_Delay(1,1);%归一化时延
normAmp=Amp_Delay(:,2)/Amp_Delay(1,2);%归一化幅度
 
%4PSK调制
modulated_X1=PSK4_modulation(X);
Error_rate1=zeros(1,4000);
SNR1=zeros(1,4000);
modulated_X2=conv(modulated_X1,normAmp);
modulated_X=modulated_X2(1:length(modulated_X1));
 
%4PSK解调并画误码率曲线
for n=1:4000
    noised_X1=awgn(modulated_X,n/16,'measured');
    power_of_signal1=sum(modulated_X.^2)/length(modulated_X);
    power_of_noise1=sum(abs(noised_X1-modulated_X).^2)/length(modulated_X);
    SNR1(n)=10*log10(power_of_signal1/power_of_noise1);
    demodulated_X1=PSK4_demodulation(noised_X1);
    Error_number1=sum(abs(demodulated_X1-X));
    Error_rate1(n)=Error_number1/N;
end
figure;
semilogy(SNR1,Error_rate1);
hold on;
grid on;
legend('4PSK误码率');
xlabel('信噪比SNR(dB)');
ylabel('误码率Pe');
xlim([-25,-10]);
ylim([0.3,0.4]);
