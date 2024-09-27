function B = beam_pattern(theta, phi, p, w, lambda, T)
%ARRAY_MANIFOLD: Calculate the array manifold vector of a given array
%geometry for a given plane wave.
%
%   ASSUMPTIONS:
%   1) Array elements are all isotropic and uniformly weighted.
%   2) The wave incident on the array is assumed to be in the far-field.
%
%   INPUTS:
%   1) theta: - Incident plane wave elevation angle in degrees (spherical coordinates)
%   2) phi: - Incident plane wave azimuth angle in degrees (spherical coordinates)
%   3) p: - Nx3 vector where N is the number of elements in the array. The 3
%   refers to the location in rectangular coordinates, x,y,z. A linear
%   array takes the form [0, 0, z_1, ..., z_n]
%   4) w: - Element weighting vector. Set to 1/N to normalize to N.
%   5) lambda: - The wavelength of the incident wave, expressed in meters.
%   For a normalized response, set lambda = 1
%
%   OUTPUTS:
%   1) v - The array manifold vector
%
%   References:
%   1) Optimal Array Processing - Van Trees (Chapter 2)

% Number of antenna elements
N = size(p,1);

theta = theta*pi/180;
phi = phi*pi/180;

% 2.15
a = [-sin(theta) .* cos(phi); ...
    -sin(theta) .* sin(phi); ...
    -cos(theta)];

% 2.20
u = -a;

% 2.25
k = -(2*pi / lambda) * u;

% 2.27
wT_n = k.' * p;

% 2.28 - array manifold vector
v_k = exp( -1j * wT_n);

% Arbitrary signal response
fc = physconst('lightspeed')/lambda; %carrier
fs = 2*fc; %assume nyquist
t = 0:1/fs:T-1/fs;

signal = 10^(a/20)*exp(1j*2*pi*fc*t);

% 2.32
H_t = (1/N)*v_k';

% 2.38 
B = H_t * v_k;

end

