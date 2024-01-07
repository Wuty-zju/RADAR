function y=plot_2way_f_dtft(x1,x2)

    n=0:1:length(x1)-1;                          %原信号是1行8列的矩阵
    w=[-800:1:800]*4*pi/800;            %频域共-800----+800 的长度    
    
    X1=x1*exp(-j*(n'*w));               %求dtft变换，采用原始定义的方法，对复指数分量求和而得
    subplot(2,1,1);
    plot(w/pi,abs(X1));
    xlabel('实部信号(单位是π)');
    
    X2=x2*exp(-j*(n'*w));
    subplot(2,1,2);
    plot(w/pi,abs(X2));
    xlabel('虚部信号(单位是π)');
    
    