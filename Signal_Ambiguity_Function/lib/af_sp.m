function amf=af_sp(tp,n)
    %%单载频矩形脉冲模糊函数,tp脉冲宽度，n坐标轴点数
    t=-tp:tp/n:tp;
    f=-10/tp:10/tp/n:10/tp;
    [tau,fd]=meshgrid(t,f);
    taul=(tp-abs(tau))/tp;
    mul=pi*fd.*taul*tp;
    mul=mul+eps;
    amf=abs(sin(mul)./mul.*taul);
    
    figure();    % 创建图形窗口
    surfl(tau*1e6,fd*1e-6,amf);%模糊函数图
    title('Ambiguity Function for SP signal');xlabel('\tau/us');ylabel('f_d/MHz');zlabel('|\chi(\tau,f_d)|');

    figure(); 
    contour(tau*1e6,fd*1e-6,amf,1,'b');%模糊度图
    axis([-1 1 -1 1]);
    title('Ambiguity Diagram for SP signal');xlabel('\tau/us');ylabel('f_d/MHz');

    figure(); 
    plot(t*1e6,taul(n+1,:));%距离模糊函数图
    title('Ambiguity Function of Range for SP signal');xlabel('\tau/us');ylabel('|\chi(\tau,0)|');
    xlim([-2,2])

    figure(); 
    ff=abs(sin(mul)./mul);
    ffd=ff(:,n+1);
    plot(fd*1e-6,ffd);%速度模糊函数图
    title('Ambiguity Function of Velocity for SP signal');xlabel('f_d/MHz');ylabel('|\chi(0,f_d)|');

return;
