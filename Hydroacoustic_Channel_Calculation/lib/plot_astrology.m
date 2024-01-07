function plot_astrology(a,b)
    %画出星座图
    subplot(1,1,1)
    plot(a,b,'*');
    axis([-5 5 -5 5]);
    line([-5,5],[0,0],'LineWidth',2,'Color','black');
    line([0,0],[-5,5],'LineWidth',2,'Color','black');
    title('16QAM星座图');
