function R = multiratefb(x, fs, varargin)
% SIG = MULTIRATEFB(X,FS,NUM)
% Implements a multirate filterbank
% c 2016 cdo
 
opts.passband = true;
opts.decimate = true;
 

if nargin<3,
    fbw = 1000;
else
    fbw=varargin{1};
end

%
BWS = floor(fs./(2*fbw));
decFs = fbw*2;

fl = 1; %Normalized low cut-off freq of the first filter in Hz
fh = ((fl) + (1*fbw)); %high-cut f of the first filter
 
forder = 10; %Order of the time domain filter

[bs0 as0] = butter(forder, 2*(2*fbw)./(fs), 'low'); %Decimation filter

ss = cell(BWS,1);
sf = cell(BWS,1);
sa = zeros(BWS,1);

for k = 1 : BWS,
    
    % Band-limit the signals (get passbands)
    if k<BWS && (opts.passband),
        [bs as] = butter(forder, 2*fh/fs, 'low');
        x0 = filtfilt(bs, as, x);
    else
        x0=x;
    end
    
    % Move to base band
    if k > 1
        if k <= BWS,
            if opts.passband,
                [bs as] = butter(forder, 2*fl/fs, 'high'); %Do bandpass
                x0 = filtfilt(bs, as, x0); 
            end
        end
        
        %x1 = ammod(x0,(k-1)*fbw,fs); %DSB-S
        x1 = ssbmod(x0,(k-1)*fbw,fs); %SSB-S
    else
        x1 = x0;
    end
    
    
    % Decimate the filter information
    if opts.decimate,
        x2 = filtfilt(bs0, as0, x1); % LPF
        x3 = resample(x2, decFs, fs); % Decimate.
    else
        x3 = x1;
    end
     
    ss{k,1} = x3./max(abs(x3));
    sf{k,1} = [fl fh];
    sa(k) = max(abs(x3));
    
    fl = fl + fbw; %Next band lf
    fh = fh + fbw; %Nex band hf
    
    clear x0 x1 x2 x3;
end

R.fs = decFs;
R.Num = BWS;
R.Sig = ss;
R.NVal = sa;
R.fre = sf;

end

