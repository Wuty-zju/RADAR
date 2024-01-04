%{  
    ģ������
    paraInput:
            signal :1*N matrix
            fs     :double
            Doppler cut: hz
                       ָʾ������ά������ʾλ��
                       Ĭ��Ϊ�м�
            dalay cut : ms
                        ָʾʱ��ά���ϵ���ʾλ��
                       Ĭ��Ϊ�м�
            Max_doppler :   ������ά������
            Max_delay :     ʱ��ά������
            default_cut: ���źų��ȴ���ʱ��ά������ʱ���źŵĴ���ʽ
                        "cut" :ֱ�ӽ׶��ź�
                        "resample":���ź��ز���
    returntype:
 
            ambiguity(signal, fs, varargin);
            ambi = ambiguity(signal, fs, varargin); ��ʱ����ͼ
            [ambi, timeax] = ambiguity(signal, fs, varargin); ��ʱ����ͼ
            [ambi, timeax,fd] ambiguity(signal, fs, varargin); ��ʱ����ͼ
 
            ambi:ģ������ֵ
            timeax:ʱ����
            fd:������Ƶ����
        
%} 
 
function varargout = ambiguity(signal, fs, varargin)
p = inputParser;
 
addOptional(p, "dalay_cut", 0);
addOptional(p, "Doppler_cut",0);
addOptional(p, "Max_doppler",1000,@(x)validateattributes(x,{'numeric'},{'nonnegative'}));
addOptional(p, "Max_delay",1000,@(x)validateattributes(x,{'numeric'},{'nonnegative'}));
addOptional(p, "default_cut","cut",@(s)isstring(s));
parse(p,varargin{:});
 
Max_doppler = floor(p.Results.Max_doppler);
Max_delay = floor(p.Results.Max_delay);
 
if Max_doppler <= 1 || Max_delay<= 1
    ME = MException('myComponent:inputError','������̫С');
    throw(ME);
end
 
[m, len] = size(signal);
if m > 1 && len > 1
    ME = MException('myComponent:inputError','signal must be 1 dimension');
    throw(ME);
elseif m > 1 && len == 1
    signal = signal';
    len=m;
elseif m == 0
    ME = MException('myComponent:inputError','signal is empty');
    throw(ME);
end
 
if len > Max_doppler
    Ndoppler = Max_doppler;
else 
    Ndoppler = len;
end
if len > Max_delay
    Ndelay = Max_delay;
    if strcmpi(p.Results.default_cut, "resample")
        signal = resample(signal, Max_delay, len);
    elseif strcmpi(p.Results.default_cut, "cut")
        signal = signal(1:Max_delay);
    end
else
    Ndelay = len;
end
fd=linspace(-fs/2,fs/2,Ndoppler);
t2=linspace(0,len/fs,Ndelay);
 
ambi = abs(xcorr2(bsxfun(@times,signal,exp(1j*2*pi*fd'*t2) ),signal));
timeax=[fliplr(-t2),t2(2:end)] * 1e3;
 
isplot = false;
if nargout == 0
    isplot = true;
elseif nargout == 1
    varargout{1} = ambi;
elseif nargout == 2
    varargout{1} = ambi;
    varargout{2} = timeax;
elseif nargout == 3
    varargout{1} = ambi;
    varargout{2} = timeax;
    varargout{3} = fd;
end
 
if isplot
    [~,DopplerPos] = min(abs(fd - p.Results.Doppler_cut));
    [~,DalayPos] = min(abs(timeax - p.Results.dalay_cut));
    freq = fd(DopplerPos);
    delay = timeax(DalayPos);
 
    figure(1);
    mesh(timeax,fd,ambi),grid on;
    xlabel('delay [ms]');
    ylabel('frequency[Hz]');
    zlabel('magnitude');
    title("ambiguity function");
 
    figure(2)
    plot(timeax, ambi(DopplerPos,:) )
    xlabel('delay [ms]');
    ylabel('magnitude');
    title(sprintf("dalay cut, Doppler shift freq=%.2fHz",freq) )
 
    figure(3)
    plot(fd, ambi(:,DalayPos) )
    xlabel('frequency[Hz]');
    ylabel('magnitude');  
    title(sprintf("Doppler cut,delay=%fms",delay) )
 
    figure(4)
    contour(timeax,fd,ambi)
    xlabel('frequency[Hz]');
    ylabel('delay [ms]');
    title("�ȸ���ͼ");
end
end