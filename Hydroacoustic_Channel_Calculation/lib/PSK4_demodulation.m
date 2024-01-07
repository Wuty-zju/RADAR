function [demodulated_X] =PSK4_demodulation(noised_X)
    %4PSK解调
        demodulated_X=zeros(1,length(noised_X)*2);
        for k=1:length(noised_X)
            if(real(noised_X(k))>=0)&&(imag(noised_X(k))>=0)
                demodulated_X(k*2-1)=0;
                demodulated_X(k*2)=0;
            elseif(real(noised_X(k))<0)&&(imag(noised_X(k))>=0)
                demodulated_X(k*2-1)=0;
                demodulated_X(k*2)=1;  
            elseif(real(noised_X(k))<0)&&(imag(noised_X(k))<0)
                demodulated_X(k*2-1)=1;
                demodulated_X(k*2)=0; 
            else
                demodulated_X(k*2-1)=1;
                demodulated_X(k*2)=1;  
            end
                
        end
     
    end
    