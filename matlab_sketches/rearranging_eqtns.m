% syms a b 
% eqn = (a + 2*b == 1)
% v_a = solve(eqn, a)
% v_v_b = solve(eqn, b)v_b = solve(eqn, b)b = solve(eqn, b)

syms A eta(t) Deta Deta_max sig_max a b Sp Sf lamda_opt m 

% eqn = (Deta == b * (sig_max + a) / (A * sig_max * (1-((1 + Sp)/(-Sp + (Deta / Deta_max)))) * (Deta / Deta_max)) )

%sigTV = 1 - ( (Deta/Deta_max)*(1+Sp) / (-Sp + (Deta/Deta_max)) ) 

sigTV =1 -  ((1 + Sp)/(-Sp + (Deta / Deta_max)) * (Deta / Deta_max))

sigTV =1 +  ((0.4*(1+0.5*Sp))/(0.5*Sp + (Deta / Deta_max)) * (Deta / Deta_max))


sigTL = exp(-((eta + 1 - lamda_opt) / Sf)^2) + m * (eta + 1)

%eqn = (Deta == b * (sig_max + a) / (A * sig_max * sigTV * sigTL) )

eqn = (Deta == (b * (sig_max + a) / (A * sig_max * sigTL * sigTV + a)) + b)

Deta = solve(eqn, Deta)
%Deta = vpa(Deta)

eqn = diff(eta,t) == Deta(1)
etaSol(t) = dsolve(eqn, eta(0) == 0)

% % INPUT 
% A = 1;                       % muscle activation = {0, 1}  
% eta = 0;                     % initial strain
% 
% sig_max = 134;               % max active strain sigCE kPa
% Deta_max = 2.2;              % max strain rate (lo/s) 
% a = 1;                       % coefficient of shortening heat
% b = a * Deta_max / sig_max;   
% Sp = 0.2;                    % shape factor, stress normalised to velocity, Hill shape parameter
% Sf = 0.35;                   % shape factor, stress normalised to length, Gaussian shape factor  
% lamda_opt = 1.5;             % stretch at which maximum stress occurs 
% m = 0.01;                    % slope parameter
% 
% Deta = subs(Deta)
% 
% syms eta_(t)
% 
% eqn = Deta_(,t) == a*y;




