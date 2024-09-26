function [e, u, v, w] = steeringVector(px, py, pz, lambda, theta_scanning, phi_scanning)
%steeringVector - calculate steering vector of array
%
%Calculates the steering vector for different scanning angles
%Theta is the elevation and is the normal incidence angle
%Phi is the azimuth, and is the angle in the XY-plane
%
% [e, u, v, w] = steeringVector(xPos, yPos, zPos, f, c, thetaScanAngles, phiScanAngles)
%
%IN
%xPos            - 1xP vector of x-positions [m]
%yPos            - 1xP vector of y-positions [m]
%yPos            - 1xP vector of z-positions [m]
%f               - Wave frequency [Hz]
%c               - Speed of sound [m/s]
%thetaScanAngles - 1xM vector or MxN matrix of theta scanning angles [degrees]
%phiScanAngles   - 1xN vector or MxN matrix of of phi scanning angles [degrees]
%
%OUT
%e               - MxNxP matrix of steering vectors
%u               - MxN matrix of u coordinates in UV space [sin(theta)*cos(phi)]
%v               - MxN matrix of v coordinates in UV space [sin(theta)*sin(phi)]
%w               - MxN matrix of w coordinates in UV space [cos(theta)]
%
%Created by J?rgen Grythe
%Last updated 2017-02-27

%Convert angles to radians
theta_scanning = theta_scanning*pi/180;
phi_scanning = phi_scanning*pi/180;

%Wavenumber
k = 2*pi/lambda;

%Number of elements/sensors in the array
P = numel(px);

%Calculating wave vector in spherical coordinates
N = numel(phi_scanning);

u = sin(theta_scanning)'*cos(phi_scanning);
v = sin(theta_scanning)'*sin(phi_scanning);
w = repmat(cos(theta_scanning)', 1, N);

%Calculate steering vector/matrix
uu = bsxfun(@times, u, reshape(px, 1, 1, P));
vv = bsxfun(@times, v, reshape(py, 1, 1, P));
ww = bsxfun(@times, w, reshape(pz, 1, 1, P));

e = exp(1j*k*(uu + vv + ww));

