function amf=af_sp(tp,n)
    t=-tp:tp/n:tp;
    f=-10/tp:10/tp/n:10/tp;
    [tau,fd]=meshgrid(t,f);
    taul=(tp-abs(tau))/tp;
    mul=pi*fd.*taul*tp;
    mul=mul+eps;
    amf=abs(sin(mul)./mul.*taul);
    
    figure();
    surfl(tau*1e6,fd*1e-6,amf);
    title('Ambiguity Function for SP signal');xlabel('\tau/us');ylabel('f_d/MHz');zlabel('|\chi(\tau,f_d)|');

    figure(); 
    contour(tau*1e6,fd*1e-6,amf,1,'b');
    axis([-1 1 -1 1]);
    title('Ambiguity Diagram for SP signal');xlabel('\tau/us');ylabel('f_d/MHz');

    figure(); 
    plot(t*1e6,taul(n+1,:));
    title('Ambiguity Function of Range for SP signal');xlabel('\tau/us');ylabel('|\chi(\tau,0)|');
    xlim([-2,2])

    figure(); 
    ff=abs(sin(mul)./mul);
    ffd=ff(:,n+1);
    plot(fd*1e-6,ffd);
    title('Ambiguity Function of Velocity for SP signal');xlabel('f_d/MHz');ylabel('|\chi(0,f_d)|');

return;
