clc;close all;clear all;
B=10;
tp=1;
f0=100;
u=B/tp;
t=linspace(-tp,tp,100);
signal=exp(1j*(2*pi*f0*t+pi*u*t.^2));%lfm

ambiguity(signal, 129);
