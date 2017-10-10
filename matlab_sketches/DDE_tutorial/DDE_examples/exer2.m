function sol = exer2
% Example of J.D. Farmer, Chaotic Attractors of an 
% Infinite-Dimensional Dynamical System, Physica D, 
% 4 (1982) 366-393. The Mackey-Glass equation is a 
% scalar equation that exhibits chaotic behavior.  
% Fig. 2a starts the plot with t = 50 to let an initial 
% transient settle down.

% Copyright 2002, The MathWorks, Inc.

sol = dde23(@exer2f,14,0.5,[0, 300]);
t = linspace(50,300,1000);
y = deval(sol,t);
ylag = deval(sol,t - 14);
figure
plot(y,ylag)
title('Fig. 2a of Farmer.')
xlabel('y(t)');
ylabel('y(t-14)');

%-----------------------------------------------------------------------

function yp = exer2f(t,y,Z)
%EXER2F  The derivative function for Exercise 2 of the DDE Tutorial.
yp = 0.2*Z / (1 + Z^10) - 0.1*y;
