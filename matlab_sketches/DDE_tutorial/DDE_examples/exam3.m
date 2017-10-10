function [sol1,sol2,sol3,sol4] = exam3
% Example 4.2 of H.J. Oberle and H.J. Pesch, Numerical 
% treatment of delay differential equations by Hermite 
% interpolation, Numer. Math., 37 (1981) 235-255.  This 
% problem is solved for four values of a parameter lambda.  
% Oberle and Pesch point out that the problem is numerically 
% more sensitive for the larger values of lambda, so they
% are solved with more stringent tolerances.

% Copyright 2002, The MathWorks, Inc.

sol1 = dde23(@exam3f,1,@exam3h,[0, 20],[],1.5);
figure
plot(sol1.x,sol1.y,'b')
axis([0 20 -1 7]), drawnow, hold on

sol2 = dde23(@exam3f,1,@exam3h,[0, 20],[],2);
plot(sol2.x,sol2.y,'g'), drawnow

opts = ddeset('RelTol',1e-5,'AbsTol',1e-8);
sol3 = dde23(@exam3f,1,@exam3h,[0, 20],opts,2.5);
plot(sol3.x,sol3.y,'r'), drawnow

opts = ddeset('RelTol',1e-6,'AbsTol',1e-10);
sol4 = dde23(@exam3f,1,@exam3h,[0, 20],opts,3);
plot(sol4.x,sol4.y,'k'), drawnow

legend('\lambda = 1.5','\lambda = 2.0',...
       '\lambda = 2.5','\lambda = 3.0')
title('Example 4.2 of Oberle and Pesch.')
hold off

%-----------------------------------------------------------------------

function yp = exam3f(t,y,Z,lambda)
%EXAM3F  The derivative function for the Example 3 of the DDE Tutorial.
yp = -lambda*Z*(1 + y);   

%-----------------------------------------------------------------------

function y = exam3h(t,lambda)
%EXAM3H  The history function for the Example 3 of the DDE Tutorial.
y = t;
