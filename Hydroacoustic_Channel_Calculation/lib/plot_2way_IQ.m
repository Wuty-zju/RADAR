function y=plot_2way_IQ(x1,x2) 

    subplot(2,1,1);
    hold on;
    stairs(x1);
    hold off;
    xlim([0,20]);
    ylim([-0.5,1.5]);
    xlabel('I路序列');
    
    subplot(2,1,2);
    hold on;
    stairs(x2);
    hold off;
    xlim([0,20]);
    ylim([-0.5,1.5]);
    xlabel('Q路序列');
    