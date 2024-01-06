function amf=af_lfm(B,tp,n)
    u=B/tp;
    t=-tp:tp/n:tp;
    f=-B:B/n:B;
    [tau,fd]=meshgrid(t,f);
    var1=tp-abs(tau);
    var2=pi*(fd-u*tau).*var1;
    var2=var2+eps;
    amf=abs(sin(var2)./var2.*var1/tp);
    amf=amf/max(max(amf));
    
    var3=pi*u*tau.*var1;
    taul=abs(sin(var3)./var3.*var1);
    taul=taul/max(max(taul));
    
    mul=tp*abs(sin(pi*fd*tp)./(pi*fd*tp));
    mul=mul/max(max(mul));
    
    figure();
    surfl(tau*1e6,fd*1e-6,amf);
    title('Ambiguity Function for LFM signal');xlabel('\tau/us');ylabel('f_d/MHz');zlabel('|\chi(\tau,f_d)|');
    
    figure();
    contour(tau*1e6,fd*1e-6,amf,1,'b');
    title('Ambiguity Diagram for LFM signal');xlabel('\tau/us');ylabel('f_d/MHz');
    
    figure();
    plot(t*1e6,taul(n+1,:));
    title('Ambiguity Function of Range for LFM signal');xlabel('\tau/us');ylabel('|\chi(\tau,0)|');
    
    figure();
    plot(fd*1e-6,mul(:,n+1));
    title('Ambiguity Function of Velocity for LFM signal');xlabel('f_d/MHz');ylabel('|\chi(0,f_d)|');

return


