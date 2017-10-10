function sol = exer1
% Example 1 of K.W. Neves, Automatic integration 
% of functional differential equations: an approach, 
% ACM TOMS, 1 (1975) 357-368.

% Copyright 2002, The MathWorks, Inc.

sol = dde23(@exer1f,[1, 0.5],@exer1h,[0, 1]);
figure
plot(sol.x,sol.y);
title('Example 1 of Neves.')
xlabel('time t');
ylabel('y(t)');

%-----------------------------------------------------------------------

function yp = exer1f(t,y,Z)
%EXER1F  The derivative function for Exercise 1 of the DDE Tutorial.
ylag1 = Z(:,1);
ylag2 = Z(:,2);
yp = [ ylag1(5) + ylag1(3)
       ylag1(1) + ylag2(2)
       ylag1(3) + ylag2(1)
       ylag1(5)*ylag1(4)
       ylag1(1)            ];

%-----------------------------------------------------------------------

function y = exer1h(t)
%EXER1H  The history function for Exercise 1 of the DDE Tutorial.
temp = exp(t+1);
y = [ temp; exp(t+0.5); sin(t+1); temp; temp];
