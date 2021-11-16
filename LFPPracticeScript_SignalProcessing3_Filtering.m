%% Signal Processing practice script 2 (filtering)
%   - this is a practice lfp analysis script using sample LFP data provided by Henry
%   Hallock. In this script we will filter our time-scaled and denoised signal. 
%       -07/2021 SSA

% Filtering LFP signals is a critical step for assesment and insight of
% oscillatory/ephysiological signatures during task performance; 

% i.e. high frequency oscillations during memory consolidation (sharp-wave ripples),
% single unit activity synchrony to a specific frequency band,
% phase-amplitude coupling, sleep spindle detection, measures of synchrony etc (will add more)

    % The filtering aspect w/LFP is often used in single unit activity assesment
    % but in characterizing EEG activity during a task can be useful for
    % oscillatory signature detection (more Bground research to be done)

%% THIS SCRIPT CAN/SHOULD BE COMBINED WITH Sig.Proc.1 and 2 CODE IN A REAL PROJECT ANALYSIS SETTING;

%% Load your basics
clear
% cd to data folder (where you saved your outputs from script 1 and 2)
cd ('Z:\Suhaas A\Matlab Scripts\LFP Basics Tutorials\SavedDataSets');

% load your detrend/denoised LFP signal created in Prac. script 2
load ('DetrendDenoiseSignals.mat'); 

 
% Make a data structure of your signals, not imperative but helps with organization 
lfp.PFC = AutoRmPFC;
lfp.VTA = AutoRmVTA;

%% SET YOUR TIME; EXPAND COLLAPSED CODE FOR FURTHER DETAIL IF CONFUSED
%{
srate = 2000
timeEeg = (length(lfp.PFC))/srate;
timeAxisEeg = linspace(0, timeEeg, (length(lfp.PFC))); %"give me 100001 points from 0 to the total time"
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

%% filter LFP signal for your desired freq. band
% here we'll do theta - 4-7 Hz band
%   - an easy way to assess what a function needs is to right-click->open
% in this case, the sampling rate was needed...
pfcFilt = bandpass(lfp.PFC, [4 7], 2000);
vtaFilt = bandpass(lfp.VTA, [4 7], 2000);

%% plot!
figure; hold on
subplot 421; 
plot(EEGtimePS1,lfp.PFC,'Color',[1 0 0]);
title('PFC Unfiltered');
xlabel('Time (ms or s)');
ylabel('Voltage');
hold on;
subplot 422;
plot(EEGtimePS1,pfcFilt,'Color',[1 0.4 0]);
title('PFC filtered (4-7Hz)');
xlabel('Time (ms or s)');
ylabel('Voltage');
subplot 423; 
plot(EEGtimePS1,lfp.VTA,'Color', [.4 1 0]);
title('VTA Unfiltered');
xlabel('Time (ms or s)');
ylabel('Voltage');
hold on;
subplot 424;
plot(EEGtimePS1,vtaFilt,'Color', [0.4 1 1]);
title('VTA filtered (4-7Hz)');
xlabel('Time (ms or s)');
ylabel('Voltage');
sgtitle('Raw and Bandpass Filtered');

%% Filter Options
% Another common signal filter is the 3rd degree Butterworth filter, we can
% apply that to our data to see the difference
    % better explanations on the diffs and uses coming soon
    
% butterworth
% syntax is slightly diff "open skaggs_filter_var" for help
pfcBFilt = skaggs_filter_var(lfp.PFC, 4, 7, 2000);
vtaBFilt = skaggs_filter_var(lfp.VTA, 4, 7, 2000);

%% plot!
figure; hold on
subplot 421; 
plot(EEGtimePS1,lfp.PFC,'Color',[1 0 0]);
title('PFC Unfiltered');
xlabel('Time (ms or s)');
ylabel('Voltage');
hold on;
subplot 422;
plot(EEGtimePS1,pfcBFilt,'Color',[1 0.4 0]);
title('PFC filtered (4-7Hz)');
xlabel('Time (ms or s)');
ylabel('Voltage');
subplot 423; 
plot(EEGtimePS1,lfp.VTA,'Color', [.4 1 0]);
title('VTA Unfiltered');
xlabel('Time (ms or s)');
ylabel('Voltage');
hold on;
subplot 424;
plot(EEGtimePS1,vtaBFilt,'Color', [0.4 1 1]);
title('VTA filtered (4-7Hz)');
xlabel('Time (ms or s)');
ylabel('Voltage');
sgtitle('Raw and Butterworth Filtered');

%% Lastly, compare filter types 
figure; hold on
subplot 421; 
plot(EEGtimePS1,pfcFilt,'Color',[1 0 0]);
title('PFC Bandpass');
xlabel('Time (ms or s)');
ylabel('Voltage');
hold on;
subplot 422;
plot(EEGtimePS1,pfcBFilt,'Color',[1 0.4 0]);
title('PFC Butterworth');
xlabel('Time (ms or s)');
ylabel('Voltage');
subplot 423; 
plot(EEGtimePS1,vtaFilt,'Color', [.4 1 0]);
title('VTA Bandpass');
xlabel('Time (ms or s)');
ylabel('Voltage');
hold on;
subplot 424;
plot(EEGtimePS1,vtaBFilt,'Color', [0.4 1 1]);
title('VTA Butterworth');
xlabel('Time (ms or s)');
ylabel('Voltage');
sgtitle('Comparing Filter Types');

%% Save out your preference; or both!
save('FiltLFPs', 'pfcFilt', 'pfcBFilt', 'vtaFilt', 'vtaBFilt');