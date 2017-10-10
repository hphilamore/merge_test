function sol = exer6
% Sample problem of ARCHI manual.  The absolute error 
% tolerance is set to 1e-9 to illustrate the use of 
% options.  Also, it is necessary to use the InitialY 
% option because the solution is not continuous at the
% initial point.

% Copyright 2002, The MathWorks, Inc.

options = ddeset('AbsTol',1e-9,'InitialY',[0; 0]);
sol = dde23(@exer6f,[1, 2],@exer6h,[0, 4],options);
figure
plot(sol.x,sol.y)
title('Sample Problem of ARCHI Manual.')
xlabel('time t');
ylabel('y(t)');

%-----------------------------------------------------------------------

function yp = exer6f(t,y,Z)
%EXER6F  The derivative function for Exercise 6 of the DDE Tutorial.
ylag1 = Z(:,1);
ylag2 = Z(:,2);
yp = [  ylag1(1)*ylag2(2)
       -y(1)*ylag2(2)     ];

%-----------------------------------------------------------------------

function y = exer6h(t)
%EXER6H  The history function for Exercise 6 of the DDE Tutorial.
y = [ cos(t); 
      sin(t) ];
