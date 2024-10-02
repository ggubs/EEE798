function B = arrayResponse(p, w_n, v_k, lambda, theta_scanning, phi_scanning)
%steeredResponseDelayAndSum - calculate delay and sum in frequency domain
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

% calculate correlation matrix
v_k = diag(w_n)*v_k; % element weights
H = v_k*v_k';

% allocate output
[~, nTheta] = size(W);
B = zeros(nTheta, 1);

% Apply steering vector to signal
for thetaIdx = 1:nTheta
    w = W(:,thetaIdx);
    B(thetaIdx) = w'*H*w;
end



