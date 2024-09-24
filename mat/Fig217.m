%% Polarplot example
N = 11; % no. of array elements

% MOD1: do a finer resoltion and go from -pi to +pi
n = 1000; % number of points
dTheta = 2*pi/n;
th = -pi:dTheta:pi; % theta

B = 1/N*sin(N/2*pi*cos(th))./sin(1/2*pi*cos(th)); 
BdB = 20*log10(abs(B));
% MOD2: cut off the data at the lowest disaply value.
BdB(BdB<-40) = -40;

figure(); clf
pax = polaraxes;
polarplot(th, BdB);
rlim([-40 max(BdB)]);
% MOD3: Match angle location and direction.
pax.ThetaZeroLocation = 'top';
pax.ThetaDir = 'clockwise';
pax.ThetaLim = [-180 180];
% set line color and width
h = get(gca,'Children');
set(h,'LineWidth',2,'Color',[0 0 0]);