function ant_sweep_test()
% This script creates a chirp and 


close all
f1 = 20;
f2 = 20000;
fs = 44100;
endTime = 3; % length of a sweep in one direction

x=ant_sweep(f1,f2,fs,endTime);

N_Bands = 5;
N_BW = floor(fs./(2*N_Bands));
YX = multiratefb(x, fs, N_BW);

% Spectrogram options
N_fft = 1024;
W_s = 512;
O_s = 512 - 512/4;

   figure(49), clf
   %title('Filter banked signal')
   for n = 1:N_Bands,
        subplot(N_Bands,1,N_Bands-n+1)
        %figure()
        [SFB F T] = spectrogram(YX.Sig{n}, W_s, O_s, N_fft, YX.fs);
        
        SFB = abs(SFB)./max(max(abs(SFB)));
        %SFB = 20*log10(SFB);
        %SFB = SFB - max(max(abs(SFB)));
        %SFB(SFB<-40)=-40;
        
        F = F + (n-1)*N_BW; F=F./1000;
        %mesh(T,F,abs(SFB));
        imagesc(T,F,abs(SFB));
        %axis([T(1),T(end), F(1), F(end), -40 0]);
        %view(0,90);
        %axis tight
        axis xy;
        colormap jet
        %imagesc(T,F,abs(SFB)); 
        %xlabel('Time in s'); ylabel('Frequency in Hz'); zlabel('Energy');
   end
   %xlabel('t in s')

   h=figure(52);
   h.OuterPosition = [0 0 400 400];
   [SF F T] = spectrogram(x, W_s, O_s, N_fft, fs);
   imagesc(T,F./1000,abs(SF))
   axis xy
   ylabel('f in Hz')
   xlabel('t in s')
   colormap jet
