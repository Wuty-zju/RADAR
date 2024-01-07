function [modulated_X] = PSK4_modulation(X)
    modulated_X=zeros(1,length(X)/2);
    jj=0;
    for ii=1:2:length(X)
        jj=jj+1;
        if X(ii)==0&&X(ii+1)==0
            modulated_X(jj)=exp(1i*pi/4);
        elseif X(ii)==0&&X(ii+1)==1
            modulated_X(jj)=exp(1i*3*pi/4);
        elseif X(ii)==1&&X(ii+1)==0
            modulated_X(jj)=exp(1i*5*pi/4);
        else 
            modulated_X(jj)=exp(1i*7*pi/4);
        end
    end
 
end
