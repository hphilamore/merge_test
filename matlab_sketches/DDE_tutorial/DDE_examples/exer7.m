function sol = exer7
% Marchuk immunology model of E. Hairer, S.P. Norsett, and
% G. Wanner, Solving Ordinary Differential Equations I, 
% Springer-Verlag, Berlin, 1987, p. 297 ff. There is a parameter
% h6.  Hairer, Norsett, and Wanner present two plots in Figure 
% 15.8 for h6 = 10 and h6 = 300.  Here the figure for h6 = 300 
% is reproduced.  This requires scaling of the output and 
% specification of axis. The tolerances need to be more stringent 
% than the defaults.
%
% There is a state-dependent coefficient xi(y_4(t)) that is 
% not smooth when y_4(t) = 0.1.  The parameter state = +1 if 
% y_4(t) <= 0.1, and -1 otherwise.  y_4(t) - 0.1 = 0 is a 
% terminal event.  The integration is restarted with a change 
% of sign in state.  With y_4(0) = 0, state is initialized to
% +1.  There is a discontinuity in the derivative of the history 
% function that is handled with 'Jumps'.

% Copyright 2002, The MathWorks, Inc.

h6 = 300;
state = +1;
opts = ddeset('Jumps',-1e-6,'Events',@exer7e,...
              'RelTol',1e-5,'AbsTol',1e-8);
sol = dde23(@exer7f,0.5,@exer7h,[0, 60],opts,h6,state);
while sol.x(end) < 60
   fprintf('Restart at %5.2f.\n',sol.x(end)); 
   state = -state;
   sol = dde23(@exer7f,0.5,sol,[sol.x(end), 60],opts,h6,state);
end
yplot = sol.y;
yplot(1,:) = 1e4*yplot(1,:);
yplot(2,:) = yplot(2,:)/2;
yplot(4,:) = 10*yplot(4,:);
figure
plot(sol.x,yplot)
legend('1e4*y_1','y_2/2','y_3','10*y_4',0)
title(['Marchuk immunology model with h6 = ',num2str(h6),'.'])
xlabel('Restart each time y_4(t) = 0.1.');
axis([0 60 -1 15.5])

%-----------------------------------------------------------------------

function yp = exer7f(t,y,Z,h6,state)
%EXER7F  The derivative function for Exercise 7 of the DDE Tutorial.
h1 = 2;
h2 = 0.8;
h3 = 1e4;
h4 = 0.17;
h5 = 0.5;
h7 = 0.12;
h8 = 8;
if state == +1
   xi = 1;
else
   xi = (1 - y(4))*10/9;
end
ylag = Z;
yp = [ (h1 - h2*y(3))*y(1)
        xi*h3*ylag(3)*ylag(1) - h5*(y(2) - 1)
        h4*(y(2) - y(3)) - h8*y(3)*y(1)
        h6*y(1) - h7*y(4)                     ];

%-----------------------------------------------------------------------

function y = exer7h(t,h6,state)
%EXER7H  The history function for Exercise 7 of the DDE Tutorial.
y = ones(4,1);
y(1) = max(0,1e-6 + t);  
y(4) = 0;    

%-----------------------------------------------------------------------

function [value,isterminal,direction] = exer7e(t,y,Z,h6,state)
%EXER7E  The event function for Exercise 7 of the DDE Tutorial.
value = y(4) - 0.1;
isterminal = 1;
direction = 0;
