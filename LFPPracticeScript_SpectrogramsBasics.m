%% Heatplot/spectrogram (http://www-users.med.cornell.edu/~jdvicto/pdfs/pubo08.pdf)

movingwin=[0.1 0.05]; % set the moving window dimensions
paramsS.Fs=2000; % sampling frequency
paramsS.fpass=[0 100]; % frequencies of interest
paramsS.tapers=[5 9]; % tapers
paramsS.trialave=0; % average over trials
paramsS.err=0; % no error computation

data=PFC; % data from channel 1
[S1,t,f]=mtspecgramc(data,movingwin,paramsS); % compute spectrogram
subplot(121);
plot_matrix(S1,t,f);
xlabel([timeAxisEeg]); % plot spectrogram
caxis([8 28]); colorbar;

data2=VTA; % data from channel 2
[S2,t2,f2]=mtspecgramc(data2,movingwin,paramsS); % compute spectrogram
subplot(122);
plot_matrix(S2,t2,f2);
xlabel([timeAxisEeg]); % plot spectrogram
caxis([8 28]); colorbar;