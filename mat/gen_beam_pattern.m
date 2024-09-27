% Generate an array manifold vector for uniformly weightedm isotropic 
% antenna elements of arbitrary geometry
clc; clear; close all; addpath(genpath('lib'));
et 1000 wavelengths worth of signal
% wavelength
lambda = 1;

% spacing factor
d = lambda/2;

% integration time
T = 1e3*(lambda)^-1; % integrate over 1000 wavelengths 

% array geometry
p = [
    0 0 -3*d;...
    0 0 -2*d;...
    0 0 1*d;...
    0 0 3*d;...
    ].';

% array element impulse responses
h = ones(length(p),1);

% beam pattern params (polar coordinates)
theta = 15; 
phi = 0; % fix theta to the orthogonal plane

w = ones(1,length(p))/length(p);

Y = beam_pattern(theta, phi, p, w, lambda);
plot(abs(Y))
