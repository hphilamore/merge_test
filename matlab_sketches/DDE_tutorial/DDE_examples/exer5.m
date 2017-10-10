function sol = exer5
% D.R. Wille' and C.T.H. Baker use Example 4 of DELSOL--
% a numerical code for the solution of systems of delay-
% differential equations, Appl. Numer. Math., 9 (992) 
% 223-234 to illustrate a discontinuous history. DDE23 
% treats any order discontinuity in the history as a 
% discontinuity in the solution itself, which is actually 
% the case for this example.

% Copyright 2002, The MathWorks, Inc.

opts = ddeset('Jumps',[-1,-4/5,-3/5,-2/5,-1/5]);
sol = dde23(@exer5f,1,@exer5h,[0, 1],opts);
figure
plot(sol.x,sol.y)
title('Example 4 of Wille'' and Baker.')
xlabel('time t');
ylabel('y(t)');

%-----------------------------------------------------------------------

function yp = exer5f(t,y,Z)
%EXER5F  The derivative function for Exercise 5 of the DDE Tutorial.
yp = Z;

%-----------------------------------------------------------------------

function y = exer5h(t)
%EXER5H  The history function for Exercise 5 of the DDE Tutorial.
y = (-1)^floor(-5*t);
