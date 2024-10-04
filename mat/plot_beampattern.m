clc; clear; close all; addpath(genpath('lib'));
c = physconst('lightspeed');

plots = true;

%% Simulation Setup
% receiver params
fs = 1e9;
theta_scanning= -180:1:180;
phi_scanning = -90:1:90;

% received signal angle of arrival
theta_incident = 45; % degrees (0-degree broadside)
phi_incident = 45;

% received signal specification
f = 100e6;
lambda = c/f;
a = 0; % db

% array specification
ULA = 0;

N = 11;
d = lambda/2;

if ULA
    % Construct a uniform linear array with lamda/2 spacing
    px = ((0:(N-1))-((N-1)/2))*d; % ULA
    py = zeros(1, numel(px));
else
    % Construct a circular array with 0.6lamda radius
    [px, py] = pol2cart(linspace(0,2*pi-2*pi/N,N),ones(1,N)*2*0.6*d);
end
pz = zeros(1, numel(px));

% create element position matrix
p = [px; py; pz];

% create element weights
w_n = ones(1, numel(px))/numel(p)/3;

%% Computation
% synthesize manifold vector for incident to array
v_k = manifoldVector(p, lambda, theta_incident, phi_incident);

% calculate array response to the incident waveform at desired scanning
% angles
B = zeros(length(theta_scanning), length(phi_scanning));

%%% THIS IS WHERE THE MAGIC HAPPENS %%%
% compute the response at each elevation angle. The function accepts theta
% (azimuth) as a vector, but only accepts scalar values for phi (elevation).
for t = 1:length(phi_scanning)
    B(:,t) = arrayResponse(p, w_n, v_k, lambda, theta_scanning, phi_scanning(t));
end

% normalize the beampattern for plotting
B = abs(B)/max(abs(B(:)));

%% Plotting - these functions are kind of a mess internally but they work OK
% plot the result at the proper elevation angle
if plots

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
    figure(2)
    plot3Darray(p, d*N, theta_incident, phi_incident)
    title('Array Geometry w/ incident wavenumber')
    subtitle(['\theta = ' num2str(theta_incident), ', \phi = ' num2str(phi_incident)])
    xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]')

    % plot 3d beam pattern response
    figure(3)
    plot3Dpattern(B.',theta_scanning,phi_scanning)
    title('3D Array response for a given wavenumber')
    subtitle(['\theta = ' num2str(theta_incident), ', \phi = ' num2str(phi_incident)])
    xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]')
end
