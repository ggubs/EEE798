clc; clear; close all; addpath(genpath('lib'));
c = physconst('lightspeed');

%% Simulation Setup
% receiver params
fs = 1e9;
theta_scanning= -180:1:180;
phi_scanning = -90:1:90;

% received signal angle of arrival
theta_incident = 90; % degrees (0-degree broadside)
phi_incident = 0;

% received signal specification
f = 100e6;
lambda = c/f;
a = 0; % db


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
B = zeros(length(theta_scanning), length(phi_scanning));

% compute the response at each elevation angle
for t = 1:length(phi_scanning)
    B(:,t) = arrayResponse(p, w_n, v_k, lambda, theta_scanning, phi_scanning(t));
end

% normalize the beampattern
B = abs(B)/max(abs(B(:)));

%% Plotting
% plot the result at the proper elevation angle

phiIdx = find(phi_scanning == phi_incident);

figure(1)
plot(theta_scanning,20*log10(B(:, phiIdx)))
title('Frequency-Wave-number Array Response');
subtitle(['\theta = ' num2str(theta_incident), ', \phi = ' num2str(phi_incident)])
xlabel('\theta'); ylabel('dB');
xlim([min(theta_scanning) max(theta_scanning)])
grid on

% find vector index corresponding to signal aoa and plot that too
idx = find(theta_scanning >= theta_incident,1);
line([theta_scanning(idx) theta_scanning(idx)],get(gca,'YLim'));
legend('Array Response', 'AoA (\theta)')

% plot array geometry and incident wave
[wx, wy, wz] = sph2cart(deg2rad(theta_incident-90),deg2rad(phi_incident),d*N/2);

figure(2)
scatter3(px,py,pz, LineWidth=2)
xlim([-10 10])
ylim([-10 10])
zlim([-10 10])

hold on
p0 = [wx, wy, wz];
p1 = [0, 0, 0];
vectarrow(p0, p1)
title('Array Geometry w/ incident wavenumber')
subtitle(['\theta = ' num2str(theta_incident), ', \phi = ' num2str(phi_incident)])
xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]')
grid on
hold off

% plot 3d beam pattern response
figure(3)
patternCustom(B.',theta_scanning,phi_scanning)
title('3D Array response for a given wavenumber')
subtitle(['\theta = ' num2str(theta_incident), ', \phi = ' num2str(phi_incident)])
