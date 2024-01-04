function [sig, taxis] = dl_genLFM(T, fs, t1, tau, f1, B, winType)
%DL_GENLFM Generate LFM Chirp Signal
% [SIG, TAXIS] = dl_genLFM(T, FS, T1, TAU, F1, B, WINTYPE) generate a time
% domain signal SIG and corresponding time axis TAXIS that contain a LFM 
% chirp signal with following parameters:
%
%   T       total duration of the signal (secs)
%   FS      sampling frequency (Hz)
%   T1      start time of the chirp signal (secs)
%   TAU     duration of the chirp (secs)
%   F1      start frequency of the chirp (Hz)
%   B       bandwidth of the chirp (Hz)
%   WINTYPE     type of the window function (valid value includes 'rec', 'hann', and 'tukey')
%

% signal length
sigLength = ceil(T*fs);

% generate [taxis]
dt = 1/fs;
taxis = 0:dt:(sigLength-1)*dt;

% generate [sig]
sig = zeros(size(taxis));
in = find( taxis>=t1 & taxis<=(t1+tau) );
sig(in) = 1/sqrt(T) * exp( -1i*2*pi*( f1*(taxis(in)-t1) + B./(2*tau)*(taxis(in)-t1).^2 ) );

% Define taper window
switch winType
    case 'rec'
        wt = ones(length(taxis), 1);
    case 'hanning'
        wt = zeros(length(taxis), 1);
        wt(in) = 0.1 + 0.9*hann(length(in));
    case 'tukey'
        wt = zeros(length(taxis), 1);
%         wt(in) = 0.1 + 0.9*tukeywin(length(in), 0.25);
        wt(in) = tukeywin(length(in), 0.25);
    otherwise
        error('wrong window input ''%s''\nValid input are ''rec'', ''hanning'', and ''tukey''', winType);
end

sig = wt'.*sig*sqrt(T);

end