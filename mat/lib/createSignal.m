function signal = createSignal(px, py, pz, f, c, fs, theta_incident, phi_incident, a, nSamps)
%createSignal - create input signal to an array 

%Create signal hitting the array
v = steeringVector(px, py, pz, f, c, theta_incident, phi_incident);
v = squeeze(v);

%Add random phase to make signals incoherent
T = nSamps/fs;
t = 0:1/fs:T-1/fs;
signal = 10^(a/20)*v*exp(1j*2*pi*f*t);

