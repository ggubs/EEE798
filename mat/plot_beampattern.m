clc; clear; close all; addpath(genpath('lib'));
c = physconst('lightspeed');

%% Simulation Setup
% receiver params
fs = 1e9;
theta_scanning= -90:1:90;
phi_scanning = 0;

% received signal specification
f = 100e6;
theta_incident = 20; % degrees
phi_incident = 15;
a = 0; % db
lambda = c/f;

% array specification
N = 11;
d = lambda/2;
px = ((0:(N-1))-((N-1)/2))*d; % ULA
py = zeros(1, numel(px));
pz = zeros(1, numel(px));

% create element position matrix
p = [px; py; pz];

% create element weights
w_n = ones(1, numel(px))/numel(p)/3;

%% Computation
% synthesize signal incident to array
v_k = manifoldVector(p, lambda, theta_incident, phi_incident);

% calculate array response to the incident waveform at desired scanning
% angles
B = arrayResponse(p, w_n, v_k, lambda, theta_scanning, phi_scanning);

% normalize the beampattern
B = abs(B(:))/max(abs(B(:)));

%% Plotting
% plot the result
figure(1)
plot(theta_scanning,20*log10(B(:)))
title('Frequency-Wave-number Array Response');
subtitle(['\theta = ' num2str(theta_incident), ', \phi = ' num2str(phi_incident)])
xlabel('\theta'); ylabel('dB');
grid on

% find vector index corresponding to signal aoa and plot that too
idx = find(theta_scanning >= theta_incident,1);
line([theta_scanning(idx) theta_scanning(idx)],get(gca,'YLim'));
legend('Array Response', 'AoA (\theta)')

% plot array geometry and incident wave
[wx, wy, wz] = sph2cart(theta_incident,phi_incident,d*N);

figure(2)
scatter3(px,py,pz, LineWidth=2)
hold on
%plot3([0, wx], [0 wy], [0 wz])
p0 = [wx, wy, wz];
p1 = [0, 0, 0];
vectarrow(p0, p1)
hold off
title('Array Geometry')
subtitle(['\theta = ' num2str(theta_incident), ', \phi = ' num2str(phi_incident)])
xlabel('x (m'); ylabel('y (m'); zlabel('z (m')
grid on
