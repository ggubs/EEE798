function B = arrayResponse(p, w_n, v_k, lambda, theta_scanning, phi_scanning)
%
%IN
%p                   - 3xP vector of positions [m]
%w_n                 - 1xP vector of element weights
%v_k                 - MxP array manifold vector for M given wavenumbers
%lambda              - signal carrier wavelength
%theta_scanning      - 1xM vector of theta scanning angles [degrees]
%phi_scanning        - 1x1 scalar of phi scanning angle [degrees]
%
%OUT
%B                   - 1xM beam pattern response for the given manifold

% calculate steering vector for all scanning angles
W = manifoldVector(p, lambda, theta_scanning, phi_scanning);

% 2.32
v_k = diag(w_n)*v_k; % element weights (normalized, typically)

% 2.36 - so this is the array response for a given incident wavenumber
% its also a correlation matrix? am i understanding this right?
H = v_k*v_k';

% allocate output
[~, nTheta] = size(W);
B = zeros(nTheta, 1);

% Apply steering vector (array manifold) to signal for every azimuth angle
for thetaIdx = 1:nTheta
    w = W(:,thetaIdx);
    % 2.38 - and this is effectively a projection of that array response
    % onto a different steering angle, where the result is the array
    % response as a function of that steering angle
    B(thetaIdx) = w'*H*w;
end



