%% Signal Processing practice script 2(denoising your signal)
%   - this is a practice lfp analysis script using sample LFP data provided by Henry
%   Hallock. In this script the user will learn to denoise a recorded EEG signal. 
%       -07/2021 SSA

%% Running this script, line by line, or section by section, is recommended 
% additionally if the user is comfortable with the concepts, skip to the
% bottom of the script for a truncated workflow

%% THIS SCRIPT CAN/SHOULD BE COMBINED WITH Sig.Proc.1 CODE IN A REAL PROJECT ANALYSIS SETTING;

%% Load your basics
clear
% cd to data folder (where you saved your outputs from script 1)
cd ('Z:\Suhaas A\Matlab Scripts\LFP Basics Tutorials\SavedDataSets');

% load your timescaled LFP signal created in Prac. script 1
load ('PFC_VTA_sample1.mat');

% Make a data structure of your signals, not imperative but helps with
% organization 
lfp.PFC = PFC;
lfp.VTA = VTA;
%% SET YOUR TIME; EXPAND COLLAPSED CODE FOR FURTHER DETAIL IF CONFUSED
%{
srate = 2000
timeEeg = (length(lfp.PFC))/srate;
EEGtimePS1 = linspace(0, timeEeg, (length(lfp.PFC))); %"give me 100001 points from 0 to the total time"
%}
% load EEG time-axis from P.S.1
load('TimeScaleAxis.mat');

% Quick plot
%{
figure; hold on
subplot 121; 
plot(EEGtimePS1,lfp.PFC,'Color',[.3 0 0]);
title('PFC');
xlabel('Time (ms or s)');
ylabel('Voltage');
hold on;
subplot 122;
plot(EEGtimePS1,lfp.PFC,'Color',[.3 .4 0]);
title('VTA');
xlabel('Time (ms or s)');
ylabel('Voltage');
sgtitle('PFC and VTA LFP samples time-scaled');
%}

%% Denoising your signal; methods sourced from/elaborated on in PDF(http://www-users.med.cornell.edu/~jdvicto/pdfs/pubo08.pdf), 
% an electrical recording can be driven and/or contaminated by noise, breathing,
% chewing, or shifting of baseline voltages, and thus be inaccurately
% interpreted; To combat this we can essentially scrub our recorded signals
% With Chronux, this can be done using a local linear regression, using the
% function 'locdetrend'. This function uses a moving window set in params,
% and creates a best fitting line, which can be removed from the original
% signal.

%% Using a chronux function, we can first 'detrend' the data
% or use a local linear regression, to characterize, then remove (from the
% original signal), a line of best fit assumed to estimate slow fluctuation
% thought to be caused by electrostatic charge build-up (aka contaminant)

PFC_detrend = locdetrend_SSA(PFC,2000,[.1 .05]); %moving window of 100ms total and 50ms shifts

% Visualize the after...
figure;
subplot 131;
plot(EEGtimePS1,lfp.PFC,'Color',[.3 .4 0]);
title('LFP(PFC) Raw');
xlabel('Time (ms or s)');
ylabel('Voltage')
subplot 132;
plot(EEGtimePS1,lfp.PFC,'Color',[.3 .4 0]);
hold on
plot(EEGtimePS1,runline, 'r');
title('LFP(PFC) detrend process');
xlabel('Time (ms or s)');
ylabel('Voltage');
legend('Raw LFP','LOBFit to be subtracted');
subplot 133;
plot(EEGtimePS1,PFC_detrend,'Color',[.3 0 0]);
title('LFP(PFC) detrend outcome');
xlabel('Time (ms or s)');
ylabel('Voltage');
sgtitle('LFP sample detrending');

% as you can tell it cleans up the signal, there is less low-end and
% high-end, and the signal overall is tighter to the 'throughline'



% if satisfactory, can replace original with detrended;
% "original variable = new variable"
%% Remove 60Hz or noisy/contaminating freqs,
% so we should visualize the power spectrum in order to see if any/what
% freqs are unnaturaly 'poking out'
% we can do this using mtspectrumc (further elaborated in prac script 'PowerExtractionAndVisualization') 
% Params necc. 
paramsSpec.tapers = [5 9];
paramsSpec.pad = 0;
paramsSpec.Fs = 2000;
paramsSpec.fpass = [0 200];
paramsSpec.err = [2 0.05];
paramsSpec.trialave = 0;


% Detrended signal power spectrum
[Sdet,fdet,Serrdet] = mtspectrumc(PFC_detrend, paramsSpec);
                                                    %% Quick Side-note
                                                        % Here is another way to visualize the affect of detrending using spectrum
                                                        % this is a more robust visual...
                                                        % Real Raw spectrum
                                                        [S,f,Serr] = mtspectrumc(PFC,paramsSpec);
                                                        figure;
                                                        subplot 121
                                                        plot(f, S,'r');  hold on 
                                                        title ('Raw signal power');
                                                        subplot 122
                                                        plot(fdet,Sdet,'b');
                                                        ylim ([0 200]); % setting our axis as equal 
                                                        title ('Detrended signal power');

                                                        % Informally analyzing here, there could be something to be said about
                                                        % detrending, and further uncovering noise based frequencies, i.e. 60 120 180
                                                        % keep going if that is unclear

%% Visualize
figure
plot(fdet, Sdet,'r');  hold on 
rectangle('Position',[59 0 2 70], 'Curvature',.2, 'EdgeColor','b', 'LineWidth', 1);
rectangle('Position',[119 0 2 70], 'Curvature',.2, 'EdgeColor','b', 'LineWidth', 1);
rectangle('Position',[179 0 2 70], 'Curvature',.2, 'EdgeColor','b', 'LineWidth', 1);

% now we can assess the freq. spectrum of our signal; In this case, it
% looks like theres a harmonic, a common occurrence in in-vivo ephys, at 60, 120, 180 Hz...

% We can use rmlinesc; a chronux function made to remove user indicated sinusoids
% or auto-remove all those whose power exceeds a criterion in a populated
% distribution; although there is an auto option (default), it can still
% be worth it to assess your recordings

% Auto setting for function using f-statistic; see how it works for your dataset
AutoRmPFC = rmlinesc(PFC_detrend,paramsSpec,'n');

% Inspect the outcome
[Sauto,fauto,Serrauto] = mtspectrumc(AutoRmPFC, paramsSpec);

% Visualize
figure;
subplot 121
plot(fdet, Sdet); hold on 
xlabel('Frequency');
ylabel('Power');
title('Raw detrended spectrum');
subplot 122
plot(fauto,Sauto,'k'); hold on 
xlabel('Frequency');
ylabel('Power');
title('Denoised detrended spectrum');
sgtitle ('Line removal using auto setting');


% Manual setting for function
ManRmPFC1 = rmlinesc(PFC_detrend,paramsSpec,.05/(length(PFC_detrend)),'n',60); 
ManRmPFC2 = rmlinesc(ManRmPFC1,paramsSpec,.05/(length(PFC_detrend)),'n',120); 
ManRmPFC = rmlinesc(ManRmPFC2,paramsSpec,.05/(length(PFC_detrend)),'n',180); 

ManRmPFC = rmlinesc(PFC_detrend,paramsSpec,.05/(length(PFC_detrend)),'n',60); 
ManRmPFC = rmlinesc(ManRmPFC,paramsSpec,.05/(length(PFC_detrend)),'n',120); 
ManRmPFC = rmlinesc(ManRmPFC,paramsSpec,.05/(length(PFC_detrend)),'n',180); 
% Inspect the outcome
[Sman,fman,Serrman] = mtspectrumc(ManRmPFC, paramsSpec);

% Visualize
figure;
subplot 121
plot(fdet, Sdet); hold on 
xlabel('Frequency');
ylabel('Log transformed Power');
title('Raw detrended spectrum');
subplot 122
plot(fman, Sman,'g');hold on 
xlabel('Frequency');
ylabel('Power');
title('Denoised detrended spectrum');
sgtitle ('Line removal using manual setting');

%% Compare manual and auto further
figure;
subplot 121
plot(fauto,Sauto,'k'); hold on 
xlabel('Frequency');
ylabel('Power');
title('Auto');
subplot 122
plot(fman, Sman,'g');hold on 
xlabel('Frequency');
ylabel('Power');
title('Manual');
sgtitle ('Auto vs Manual');

% I would say its very close, but the auto feature performed a bit better,
% specifically in removal of some other suspect power signatures,
% specifically the 140Hz jump 

%% VTA Processing
% Now that we know which sinusoidal removal setting we prefer, and we've
% verified efficiency to a degree on the PFC signal, we can repeat the
% process for our VTA signal, with less in depth observation

% Detrend
% If desired, try to plot the raw VTA LFP signal on your own to see the
% difference after detrending below
VTA_detrend = locdetrend_SSA(VTA,2000,[.1 .05]); %moving window of 100ms total and 50ms shifts
figure; plot(EEGtimePS1,VTA_detrend,'Color',[.3 0 0]);
title('LFP(VTA) detrend outcome');
xlabel('Time (ms or s)');
ylabel('Voltage');


% REMEMBER, YOU WILL STILL NEED YOUR PARAMS, DEFINED ABOVE

% Denoise 
% Raw spectrum; plot if youd like
[SVTAdet,fVTAdet,SerrVTAdet] = mtspectrumc(VTA_detrend, paramsSpec);
figure
plot(fVTAdet,SVTAdet);
xlabel('Frequency (Hz)');
ylabel('Power');
title ('VTA spectrum detrended');

% Denoise 
AutoRmVTA = rmlinesc(VTA_detrend,paramsSpec,'n');

% Denoised spectrum; plot if youd like
[SVTAaut,fVTAaut,SerrVTAaut] = mtspectrumc(AutoRmVTA, paramsSpec);
figure;
plot( fVTAaut,SVTAaut); 
xlabel('Frequency (Hz)');
ylabel('Log transformed Power');
title ('VTA spectrum denoised');


%% Save out your detrended and denoised signals for future use
save('DetrendDenoiseSignals', 'PFC_detrend', 'VTA_detrend', 'AutoRmPFC', 'AutoRmVTA');
