clc; clear; close all; addpath(genpath('lib'));
c = physconst('lightspeed');

% receiver params
fs = 1e9;
integration_time = 1e-6;
theta_scanning= -90:1:90;
phi_scanning = 0;

% derived
t = 0:1/fs:integration_time-1/fs;
nSamps = fs*integration_time;

% received signal specification
f = 100e6;
theta_incident = 20; % degrees
phi_incident = 0;
a = 0; % db
lambda = c/f;

% array specification
N = 11;
d = lambda/2;
px = ((0:(N-1))-((N-1)/2))*d; % ULA
py = zeros(1, numel(px));
pz = zeros(1, numel(px));
w_n = ones(1, numel(px))/numel(px);

% synthesize signal incident to array
signal = createSignal(px, py, pz, lambda, fs, theta_incident, phi_incident, a, nSamps);

% calculate array response to the incident waveform at desired scanning
% angles
S(:) = steeredResponseDelayAndSumOptimized(px, py, pz, w_n, signal, lambda, theta_scanning, phi_scanning);

% normalize the beampattern
S(:) = abs(S(:))/max(abs(S(:))); %normalisation

% plot the result
plot(theta_scanning,20*log10(S(:)))
grid on
xlabel('\theta'); ylabel('dB');
title('Beampattern(DOA)')

% find vector index corresponding to signal aoa and plot that too
idx = find(theta_scanning >= theta_incident,1); 
line([theta_scanning(idx) theta_scanning(idx)],get(gca,'YLim'),'LineStyle','--');

legend('Array Response', 'AoA')
