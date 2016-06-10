function varargout = ant_sweep(f1,f2,fs,timel, varargin)
%x = ANT_SWEEP(f1, f2, f2, timel)
%[x t] = ANT_SWEEP(f1, f2, fs, timel, mirror)
%
% ANT_SWEEP creates a chirp from F1 Hz to F2 Hz by
% calculating the integral of the instantaneous fre-
% quency.
%
% c 2016 Carlos de Obaldia, HSU
% carlosa-at-deobaldia-dot-com
% 
if nargin > 4,
	mirror = varargin{1}; %Flag to do an up-down sweep
else
	mirror = true;
end

N = timel * fs;
if mirror, 
	freq = [linspace(f1, f2, N) linspace(f2, f1, N)];
else
	freq = linspace(f1, f2, N);
end
phase = 2 * pi * cumsum(freq) / fs;

x = sin(phase);
if mirror,
	t = linspace(0, timel* 2, length(x));
else
	t = linspace(0, timel, length(x));
end

% Prepare output 
if nargout == 1,
	varargout{1} = x;
elseif nargout == 2,
	varargout{2} = t;
	varargout{1} = x;
else
	ME = MExceptions('ANT_Sweep:NoOutput',...
					'No output handle');
	throw(ME);
end
