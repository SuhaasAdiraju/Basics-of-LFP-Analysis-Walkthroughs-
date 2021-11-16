%% COHERENCY
% Analyze coherency between two signals
%   -using chronux toolbox (free product from chronux website); coherencyc is an
%   analysis of the coherency between two signals; 
%       - Use syntax "help _____(function name)" to refer to the definition
%       of inputs etc for the functions

% function [C,phi,S12,S1,S2,f,confC,phistd,Cerr]=coherencyc(data1,data2,params)

% load your data 
load ('PFC_VTA_sample1.mat');

% Make a data structure of your signals, not imparitive but helps with
% organization 
lfp.PFC = PFC;
lfp.VTA = VTA;

% set params (as a structure)
params.tapers = [5 9];
params.pad = 0;
params.Fs = 2000;
params.fpass = [0 200];
params.err = [2 0.05];
params.trialave = 0;

[C,phi,S12,S1,S2,f,confC,phistd,Cerr]=coherencyc(lfp.PFC,lfp.VTA,params);

% this will be frequency on the x-axis, magnitude of coherence on the y;
figure; 
plot(f,C); hold on;
title('Coherence')
ylabel('Magnitude')
xlabel('Frequencies')

figure; 
plot(phi,C); hold on;
title('Coherence')
ylabel('Magnitude')
xlabel('Frequencies')
% Analysis directions...
%   - maybe phase amp. coupling??