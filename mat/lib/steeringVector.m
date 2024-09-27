function [e, uh, vh, wh] = steeringVector(px, py, pz, lambda, theta, phi)
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

if ~isscalar(phi)
    error(['Phi must be a scalar. This function only generates a response for' ...
        'a single elevation angle. Loop over the function to generate a response ' ...
        'in 3-dimensions.'])
end

%Convert angles to radians
theta = theta*pi/180;
phi = phi*pi/180;

%Wavenumber
k = 2*pi/lambda;

%Number of elements/sensors in the array
N = numel(px);

%Calculating wave vector in spherical coordinates
uh = sin(theta)'*cos(phi);
vh = sin(theta)'*sin(phi);
wh = cos(theta)';

%Calculate steering vector/matrix
uu = bsxfun(@times, uh, reshape(px, 1, 1, N));
vv = bsxfun(@times, vh, reshape(py, 1, 1, N));
ww = bsxfun(@times, wh, reshape(pz, 1, 1, N));

e = exp(1j*k*(uu + vv + ww));


% calculate the wave vectors for the given angles
u = [sin(theta)'*cos(phi),...
    sin(theta)'*sin(phi),...
    cos(theta)'].';

k = (-2*pi/lambda) * u;
p = [px;py;pz];

% calculate the array response at each wave vector
nAngles = length(theta);
wtn = zeros(N, nAngles);

for idx = 1:nAngles
    wtn(:,idx) = (k(:,idx).'*p).';
end

v = exp(1j*k*(sum(wtn,1)));

keyboard
