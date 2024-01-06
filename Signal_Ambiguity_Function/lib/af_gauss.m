function amf=af_gauss(sigma,tp,n)
    t=-tp:tp/n:tp;
    f=-8/tp:8/tp/n:8/tp;
    [tau,fd]=meshgrid(t,f);
    taul=exp(-(tau.^2./(4*sigma.^2)));
    mul=exp(-(pi^2.*sigma.^2.*fd.^2));
    mul=mul+eps;
    amf=taul.*mul;
    
    figure();
    surfl(tau*1e6,fd*1e-6,amf);grid on;
    title('Ambiguity Function for Gaussian Pulse Signal');xlabel('\tau/us');ylabel('f_d/MHz');zlabel('|\chi(\tau,f_d)|');
    
    figure();
    contour(tau*1e6,fd*1e-6,amf,1,'b');grid on;
    xlim([-2,2]);
    title('Ambiguity Diagram for Gaussian Pulse Signal');xlabel('\tau/us');ylabel('f_d/MHz');
    
    figure();
    plot(t*1e6,taul(n+1,:));grid on;
    title('Ambiguity Function of Range for Gaussian Pulse Signal');xlabel('\tau/us');ylabel('|\chi(\tau,0)|');
    
    figure();
    plot(fd*1e-6,mul(:,n+1));grid on;
    title('Ambiguity Function of Velocity for Gaussian Pulse Signal');xlabel('f_d/MHz');ylabel('|\chi(0,f_d)|');
    
return