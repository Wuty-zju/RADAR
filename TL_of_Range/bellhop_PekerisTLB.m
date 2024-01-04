clc;clear all;close all;

bellhop pekerisTLB

%%´«²¥ËðÊ§ÇúÏßÍ¼
figure
plotshd pekerisTLB.shd
[~,~,~,~,Pos,pressure] = read_shd('pekerisTLB.shd');
r = Pos.r.range/1e3;
a = abs(squeeze(pressure));
b = smoothdata(a,'movmean',21);
hold on
axis([-inf,inf,-inf,inf])
set(gca,'XScale','log')
set(gca,'YDir','normal')  
hold on
grid on

r = Pos.r.range/1e3;
a = abs(squeeze(pressure));
b = smoothdata(a,'movmean',21);

figure
plot(r,-20*log10(b));
hold on
axis([-inf,inf,-inf,inf])
title("BELLHOP-PekerisTLB-Mean-Filter")
xlabel('Range(km)')
ylabel('TL(dB)')
set(gca,'XScale','log')
set(gca,'YDir','normal')  
hold on
grid on

