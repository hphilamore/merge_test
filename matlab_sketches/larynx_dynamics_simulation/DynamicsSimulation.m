% author: manaswi, keren, hemma
% description: force displacement simulation of arytenoid cartilage
%              based on material from the book
%              Myoelastic Aerodynamic Throry of Phonation
%              by Ingo R. Titze

% NOTE: All units in mks system. angles in radians unless specified

% Tabula rasa
clear all;
close all;
clc;

%% initialize variables
F_IA = 0;
F_LCA = 0;
F_PCA = 0;
F_TA = 0;
F_CT = 0;
F_lig = 0;
F_muc = 0;

sigma_IA = 0;
sigma_LCA = 0;
sigma_PCA = 0;
sigma_TA = 0;
sigma_CT = 0;

epsilon_r = 0;
epsilon_dot_r = 0;
epsilon_t = 0;
epsilon_dot_t = 0;
xi_a = 7.1 * 10^-3;
xi_dot_a = 0;
psi_a = -7.1 * 10^-3;
psi_dot_a = 0;
theta_a = 0;
theta_dot_a = 0;

X_state = [F_IA, F_LCA, F_PCA, F_TA, F_CT, F_lig, F_muc, ...
           sigma_IA, sigma_LCA, sigma_PCA, sigma_TA, sigma_CT, ...
           epsilon_r, epsilon_dot_r, epsilon_t, epsilon_dot_t, ...
           xi_a, xi_dot_a, psi_a, psi_dot_a, theta_a, theta_dot_a];

%% define constants
% constants have been moved to the C.m file
% anything that is of the form C.Name is a constant
import C

%% define time and timestep
tMin = 0;
tMax = 100;
dt = 0.01;
nSteps = (tMax - tMin) / dt; % must be a natural number

store = zeros(3,nSteps);

% loop
for count = 1:1:nSteps
    
    time = tMin+count*dt
    
    % muscle activation
    U = ones(1,5) - 0.5*ones(1,5).*time;
    
    % update state
    X_state = simStep(X_state, U, dt);
    
    % we are interested in 
    xi_02  = C.xi_bar_02  + X_state(1,17) - C.y_CAJ * X_state(1,21)
    psi_02 = C.psi_bar_02 + X_state(1,19) - C.x_CAJ * X_state(1,21)
    
    
    store(:,count) = [time; xi_02; psi_02];
    
    plot(xi_02,psi_02, '*')
    hold on
end
















