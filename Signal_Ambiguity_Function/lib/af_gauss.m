function amf=af_gauss(sigma,tp,n)
    %% 单载频高斯脉冲模糊函数，sigma高斯函数的均方根误差，tp脉冲宽度，n坐标轴点数
    t=-tp:tp/n:tp;
    f=-8/tp:8/tp/n:8/tp;
    [tau,fd]=meshgrid(t,f);
    taul=exp(-(tau.^2./(4*sigma.^2)));
    mul=exp(-(pi^2.*sigma.^2.*fd.^2));
    mul=mul+eps;
    amf=taul.*mul;
    
    figure();    % 创建图形窗口
    surfl(tau*1e6,fd*1e-6,amf);grid on;%模糊函数图
    title('Ambiguity Function for Gaussian Pulse Signal');xlabel('\tau/us');ylabel('f_d/MHz');zlabel('|\chi(\tau,f_d)|');
    
    figure();
    contour(tau*1e6,fd*1e-6,amf,1,'b');grid on;%模糊度图
    xlim([-2,2]);
    title('Ambiguity Diagram for Gaussian Pulse Signal');xlabel('\tau/us');ylabel('f_d/MHz');
    
    figure();
    plot(t*1e6,taul(n+1,:));grid on;%距离模糊函数图
    title('Ambiguity Function of Range for Gaussian Pulse Signal');xlabel('\tau/us');ylabel('|\chi(\tau,0)|');
    
    figure();
    plot(fd*1e-6,mul(:,n+1));grid on;%速度模糊函数图
    title('Ambiguity Function of Velocity for Gaussian Pulse Signal');xlabel('f_d/MHz');ylabel('|\chi(0,f_d)|');
    
return