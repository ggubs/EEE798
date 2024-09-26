function signal = createSignal(px, py, pz, lambda, fs, theta_incident, phi_incident, a, nSamps)
%createSignal - create input signal to an array 

%Create signal hitting the array
v = steeringVector(px, py, pz, lambda, theta_incident, phi_incident);
v = squeeze(v);

%Add random phase to make signals incoherent
T = nSamps/fs;
t = 0:1/fs:T-1/fs;
f = physconst('lightspeed')/lambda;

signal = 10^(a/20)*v*exp(1j*2*pi*f*t);

