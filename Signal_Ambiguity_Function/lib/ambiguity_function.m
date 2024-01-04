%{  
    模糊函数
    paraInput:
            signal :1*N matrix
            fs     :double
            Doppler cut: hz
                       指示多普勒维度上显示位置
                       默认为中间
            dalay cut : ms
                        指示时延维度上的显示位置
                       默认为中间
            Max_doppler :   多普勒维最大点数
            Max_delay :     时延维最大点数
            default_cut: 当信号长度大于时延维最大点数时对信号的处理方式
                        "cut" :直接阶段信号
                        "resample":对信号重采样
    returntype:
 
            ambiguity(signal, fs, varargin);
            ambi = ambiguity(signal, fs, varargin); 此时不绘图
            [ambi, timeax] = ambiguity(signal, fs, varargin); 此时不绘图
            [ambi, timeax,fd] ambiguity(signal, fs, varargin); 此时不绘图
 
            ambi:模糊函数值
            timeax:时延轴
            fd:多普勒频移轴
        
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
    ME = MException('myComponent:inputError','最大点数太小');
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
    title("等高线图");
end
end