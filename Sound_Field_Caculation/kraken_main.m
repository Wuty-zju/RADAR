%%
clear
clc
close all
clf

%% Ideal
system('.\lib\kraken.exe .\env\kraken_Ideal_range')
system('.\lib\field.exe .\env\kraken_Ideal_range')
system('.\lib\kraken.exe .\env\kraken_Ideal_range_depth')
system('.\lib\field.exe .\env\kraken_Ideal_range_depth')

%% Pekeris
system('.\lib\kraken.exe .\env\kraken_Pekeris_range')
system('.\lib\field.exe .\env\kraken_Pekeris_range')
system('.\lib\kraken.exe .\env\kraken_Pekeris_range_depth')
system('.\lib\field.exe .\env\kraken_Pekeris_range_depth')
 
%% 传播损失
figure(1)
 plotshd('.\env\kraken_Ideal_range.shd')
figure(2)
 plotshd('.\env\kraken_Ideal_range_depth.shd')

figure(3)
 plotshd('.\env\kraken_Pekeris_range.shd')
figure(4)
 plotshd('.\env\kraken_Pekeris_range_depth.shd')
 
%% 模式
plotmode('.\env\kraken_Ideal_range_depth', 500, [ 1 2 3 4 ])
plotmode('.\env\kraken_Pekeris_range_depth', 500, [ 1 2 3 4 ])