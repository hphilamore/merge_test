function sol = exam2
% Example 5 of D.R. Wille' and C.T.H. Baker, DELSOL--
% a numerical code for the solution of systems of delay-
% differential equations, Appl. Numer. Math., 9 (1992) 
% 223-234.  This is an example of a scalar equation that 
% exhibits chaotic behavior. Equation (7) of the paper 
% includes a parameter gamma, but no value is specified in
% the example.  A value of -1 gives qualitative agreement 
% with Fig. 3 of the paper.  The length of the interval of 
% integration is also not given.  Here an interval [0, 100] 
% is used; it is clearly shorter than that of the figure, 
% but the qualitative behavior is seen already.

% Copyright 2004, The MathWorks, Inc.

sol = dde23(@exam2f,2,0.5,[0, 100]);
t = linspace(2,100,1000);
y = deval(sol,t);
ylag = deval(sol,t - 2);
figure
plot(y,ylag)
title('Example 5 of Wille'' and Baker.')
xlabel('y(t)');
ylabel('y(t-2)');
axis([0 1.5 0 1.5])

%-----------------------------------------------------------------------

function yp = exam2f(t,y,Z)
%EXAM2F  The derivative function for the Example 2 of the DDE Tutorial.
yp = 2*Z/(1 + Z^9.65) - y;
