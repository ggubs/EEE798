clc; clear; close all; addpath(genpath('lib'));
c = physconst('lightspeed');

plots = true;

%% Simulation Setup

% array specification
ULA = 0;

% receiver params
fs = 54e6;
theta_scanning= -180:1:180;
phi_scanning = -90:1:90;

% received signal angle of arrival
theta_incident = 55; % degrees (0-degree broadside)
phi_incident = 20;

% received signal specification
f = 100e6;
lambda = c/f;
a = 0; % db

N = 21;
d = lambda/2;

if ULA
    % Construct a uniform linear array with lamda/2 spacing
    px = ((0:(N-1))-((N-1)/2))*d; % ULA
    py = zeros(1, numel(px));
        array_diameter = N/d*1.6;

else
    % Construct a circular array with 0.6lamda radius
    [px, py] = pol2cart(linspace(0,2*pi-2*pi/N,N),ones(1,N)*2*0.6*d);
    array_diameter = 2*0.6*d*1.3;
end
pz = zeros(1, numel(px));

% create element position matrix
p = [px; py; pz];

% create element weights
w_n = ones(1, numel(p)/3)/numel(p)/3;

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

%% Plotting - these functions are kind of a mess internally but they work OK
% plot the result at the proper elevation angle
if plots

    phiIdx = find(phi_scanning == phi_incident);
    thetaIdx = find(theta_scanning == theta_incident);

    % 2D beam patterns
    figure(1)
    polarplot(deg2rad(theta_scanning), (abs(B(:, phiIdx))), LineWidth=3)
    title('Frequency-Wave-number Array Response');
    subtitle(['Elevation cut: \phi = ', num2str(phi_incident)])
    grid on

    figure(2)
    polarplot(deg2rad(phi_scanning), (abs(B(thetaIdx,:))), LineWidth=3)
    title('Frequency-Wave-number Array Response - Az Cut');
    subtitle(['Azimuth Cut: \theta = ', num2str(theta_incident)])
    grid on

    %NOTE: These plots have some issues wrt titling and axis labels, but
    %they work pretty well for now
    % plot array geometry and incident wave
    arrow_scale_h = 2*d;
    arrow_scale_w = 2*d;
    figure(3)
    plot3Darray(p, array_diameter, theta_incident, phi_incident, arrow_scale_h, arrow_scale_w) %norm(p) controls the radius of the polar plot
    title('Array Geometry w/ incident wavenumber')
    subtitle(['\theta = ' num2str(theta_incident), ', \phi = ' num2str(phi_incident)])
    xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]')

    % plot 3d beam pattern response
    figure(4)
    plot3Dpattern(B.',theta_scanning,phi_scanning)
    title('3D Array response for a given wavenumber')
    subtitle(['\theta = ' num2str(theta_incident), ', \phi = ' num2str(phi_incident)])
    xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]')
end
