function y=plot_2way_stair(x1,x2)

    subplot(2,1,1);
    hold on;
    stairs(x1);
    hold off;
    xlim([0,20]);
    ylim([-4,4]);
    xlabel('实部信号');
    
    subplot(2,1,2);
    hold on;
    stairs(x2);
    hold off;
    xlim([0,20]);
    ylim([-4,4]);
    xlabel('虚部信号');
    