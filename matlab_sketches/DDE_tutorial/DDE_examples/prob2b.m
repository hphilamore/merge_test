function sol = prob2b
%  This problem considers a cardiovascular model, which can be found in
%  'Modelling of the Baroflex-Feedback Mechanism With Time-Delay' by J.T.
%  Ottesen in J. Math. Biol., 36 (1997), 41-63.  (This is reference 
%  14 of the tutorial).

% Copyright 2002, The MathWorks, Inc.

% Problem parameters
p.ca     = 1.55;
p.cv     = 519;
p.R      = 1.05;
p.r      = 0.068;
p.Vstr   = 67.9;
p.alpha0 = 93;
p.alphas = 93;
p.alphap = 93;
p.alphaH = 0.84;
p.beta0  = 7;
p.betas  = 7;
p.betap  = 7;
p.betaH  = 1.17;
p.gammaH = 0;

P0      = 93;
Paval   = P0;
Pvval   = (1 / (1 + p.R/p.r)) * P0;
Hval    = (1 / (p.R * p.Vstr)) * (1 / (1 + p.r/p.R)) * P0;
history = [Paval; Pvval; Hval];

tau = 4;

opts = ddeset('Jumps',600);
sol = dde23(@prob2bf,tau,history,[0, 1000],opts,p);
figure
plot(sol.x,sol.y(1,:))
title(['Problem 2b. Baroflex Feedback Mechanism.' ...
       ' \tau = ',num2str(tau),'.'])
xlabel('time t')
ylabel('P_a(t)')
figure
plot(sol.x,sol.y(2,:))
legend('P_v(t)')
title(['Problem 2b. Baroflex Feedback Mechanism.' ...
       ' \tau = ',num2str(tau),'.'])
xlabel('time t')
ylabel('P_v(t)')
figure
plot(sol.x,sol.y(3,:))
title(['Problem 2b. Baroflex Feedback Mechanism.' ...
       ' \tau = ',num2str(tau),'.'])
xlabel('time t')
ylabel('H(t)')

%-----------------------------------------------------------------------

function yp = prob2bf(t,y,Z,p)
%PROB2BF  The derivative function for Problem 2b of the DDE Tutorial.
       
% Local variables are used to express the equations in terms
% of the physical quantities of the model. 
if t <= 600
   p.R = 1.05;
else
   p.R = 0.21 * exp(600-t) + 0.84;
end    
ylag = Z(:,1);
Patau = ylag(1);
Paoft = y(1);
Pvoft = y(2);
Hoft  = y(3);
dPadt = - (1 / (p.ca * p.R)) * Paoft + (1/(p.ca * p.R)) * Pvoft + ...
          (1/p.ca) * p.Vstr * Hoft;
dPvdt = (1 / (p.cv * p.R)) * Paoft - ...
        ( 1 / (p.cv * p.R) + 1 / (p.cv * p.r) ) * Pvoft;
Ts = 1 / ( 1 + (Patau / p.alphas)^p.betas );
Tp = 1 / ( 1 + (p.alphap / Paoft)^p.betap );
dHdt = (p.alphaH * Ts) / (1 + p.gammaH * Tp) - p.betaH * Tp;
yp = [ dPadt;
       dPvdt;
       dHdt ];
