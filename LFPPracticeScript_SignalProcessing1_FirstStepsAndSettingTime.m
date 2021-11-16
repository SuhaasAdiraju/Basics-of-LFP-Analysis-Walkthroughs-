%% Signal Processing practice script 2(denoising your signal)
%   this is a practice lfp analysis script using data provided by Henry
%   Hallock. In this script the user will learn to load, visualize, and set
%   an accurate timescale to a recorded EEG signal. 
%       -07.21 Suhaas S. Adiraju 

%% load your dataset;
% couple things of not here; make sure your path is either saved to the
% folders containing your sample data, or that you cd('path'); to that
% location, otherwise you'll have trouble loading / saving to the wrong
% place 

% you will need to cd to the folder containing the sample data, then cd back
% to where you would like to save your outputs

% like so; cd means change directory
cd ('Z:\Suhaas A\Matlab Scripts\LFP Basics Tutorials\SavedDataSets');
load ('PFC_VTA_sample1.mat');

cd ('YourFolderForSaving');
% Make a data structure of your signals, not imparitive but helps with
% organization; 
lfp.PFC = PFC;
lfp.VTA = VTA;

%% assess the variables; 
% in this case 2 snippets of data (LFP signal), one from PFC electrode one from VTA electrode; 

% assessment of data in matlab, at the most basic
% level, should be done by looking at the size and contents of variables,
% while simultaneously plotting the variables:

%% plot to visualize; label things for clarity and practice;
% (if confused on plot-syntax, type "help plot" or "open plot" in command window)
figure; 
subplot 121; 
plot(lfp.PFC,'Color',[.3 0 0]);
title('PFC');
xlabel('Sample #');
ylabel('Voltage');
subplot 122;
plot(lfp.VTA,'Color',[.3 .4 0]);
title('VTA');
xlabel('Sample #');
ylabel('Voltage');
sgtitle('PFC and VTA LFP samples (no time-scale)');

%% So the x axes here are arbitrary; 
% start to think about the data sets, you have to LFP signals sized 1 X 100001, 100001 is arbitrary for analysis, and only
% the amount of datapoints in the matrix (samples), EEG data must be looked at in the context of time

% Henry provided the sampling rate: 2000 Hz

% If we divide the length of our data-set, aka the number of samples by the sampling rate,
% we can yield the time course in (s)
srate = 2000    % try to softcode when possible (aka set variables rather than direct inputs)
timeEeg = (length(lfp.PFC))/srate;

% using our time variable we can use the function linspace, and plot our signals on an
% accurate timescale, linspace(X1,X2,N) plots N points between X1 and X2;
% so we can make our x-axis by input of linspace(0,(length(signal)/srate),length(signal)),
    % Don't confuse length(x) here, 
    %{
                length is how long the data set is, which
                can change depending on the context, pre-time scaling, it yields the
                number of samples in the LFP recording
     %}
    
    % In english: 
    %{
                "Give me a vector from zero to the total time of the signal
                (see timeEEG, with the number of points = the number of points in the original signal
                data set (important)."
    %}

EEGtimePS1 = linspace(0, timeEeg, (length(lfp.PFC))); %"give me 100001 points from 0 to the total time"
%% replot with added linspace value in front of 'LFP' 
% because plot(x-axis,y-axis...)
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

% Now that we've verified, save the time-axis as a separate variable
% for ease 
save('TimeScaleAxis', 'EEGtimePS1');
%% Next Steps
% Now that we have our time-scaled LFP signal, we can begin to think about
% analysis, but there are still some common cleaning/processing steps used
% for LFP signals, like detrending and denoising explored in the next
% script

%% Possible analysis directions...
%   -filter lfp for a certain freq. band
%   -Hilbert transform
%   -Gaussian (2d view)
%   -center LFP around stimulus presentation occurrence
%   -grab LFP based on behavioral data or video tracking 
