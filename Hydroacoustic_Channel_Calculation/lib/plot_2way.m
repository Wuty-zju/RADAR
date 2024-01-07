function y=plot_2way(x1,x2,len,t)
    subplot(2,1,1);
    plot((1:len)*t,x1(1:len));
    axis([0 160 -4 4]);
    hold on
    plot((1:len)*t,x1(1:len),'.','color','red');
    xlabel('实部信号');
    hold off
    subplot(2,1,2);
    plot((1:len)*t,x2(1:len));
    axis([0 160 -4 4]);
    hold on
    plot((1:len)*t,x2(1:len),'.','color','red');
    hold off
    xlabel('虚部信号');
    