function v = manifoldVector(p, lambda, theta, phi)
%
%IN
%p               - Nx3 vector of positions [m] where N is the number of array elements
%lambda          - carrier wavelength
%theta           - 1xM vector of theta scanning angles [degrees]
%phiScanAngles   - 1x1 scaler of phi scanning angles [degrees]
%
%OUT
%v               - the array manifold vector (or the steering vector)
%
%REFERENCES
%Optimum Array Processing, (Van Trees, 2022)
%

if ~isscalar(phi)
    error(['Phi must be a scalar. This function only generates a response for' ...
        'a single elevation angle. Loop over the function to generate a response ' ...
        'in 3-dimensions.'])
end

% convert degrees to radians
theta = theta*pi/180;
phi = phi*pi/180;

% nElements
N = numel(p)/3; 

% calculate the wave vectors for the given angles
% 2.15
a = [sin(theta)'*cos(phi),...
    sin(theta)'*sin(phi),...
    cos(theta)'];

% 2.20
u = -a;

% 2.25
k = u * (-2*pi/lambda); % wavenumber, 3x1 matrix

% calculate the array response at each wave vector
nTheta = length(theta);

% \omega * \tau_n -- the delay that the nth element sees for a given wavenumber, k_n
wtn = zeros(nTheta, N);    

% calculate the per element delay as a function of position and wavenumber
% for each scanning angle, theta
for idx = 1:nTheta
    % 2.27
    wtn(idx,:) = k(idx,:)*p;
end

% generate the array manifold vector
% 2.28
v = exp(1j*wtn.');

