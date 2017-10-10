function sol = prob4
%  This problem is an epidemic model due to Cooke et alia, more information
%  can be found in 'Interaction of maturation delay and nonlinear birth in
%  population and epidemic models' J. Math. Biol., 39 (1999) 332-352.
%  (This is reference 3 of the tutorial).

% Copyright 2002, The MathWorks, Inc.

T = 0.2;
lambda = 12;
sol = dde23(@prob4f,T,[2; 3.5],[0, 25],[],lambda,T);

figure
plot(sol.x,sol.y)
legend('I(t)','N(t)',0)
title(['Problem 4. Cooke et al. Epidemic Model with ' ...
       ' \lambda = ',num2str(lambda),'.'])
xlabel('time t')

%-----------------------------------------------------------------------

function yp = prob4f(t,y,Z,lambda,T)
%PROB4F  The derivative function for Problem 4 of the DDE Tutorial.
a  = 1;
b  = 80;
d  = 1;
d1 = 1;
e  = 10;
gamma = 0.5;

I = y(1);
N = y(2);
Nlag = Z(2,1);
dIdt = lambda*(N - I)*(I/N) - ( d + e + gamma)*I;
dNdt = b*exp(-a*Nlag)*Nlag*exp(-d1*T) - d*N - e*I;
yp = [ dIdt; dNdt];
