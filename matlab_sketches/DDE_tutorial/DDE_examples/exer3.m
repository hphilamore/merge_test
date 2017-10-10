function sol = exer3
% Wheldon's model of chronic granuloctic leukemia 
% from N. MacDonald, Time Lags in Biological Models, 
% Springer-Verlag, Berlin, 1978.

% Copyright 2002, The MathWorks, Inc.

for tau = [7, 20]
   sol = dde23(@exer3f,tau,[100; 100],[0, 200]);
   figure
   plot(sol.x,sol.y)
   title(['Leukemia model for \tau = ',num2str(tau),'.'])
   xlabel('time t')
   ylabel('y(t)')
end

%-----------------------------------------------------------------------

function yp = exer3f(t,y,Z)
%EXER3F  The derivative function for Exercise 3 of the DDE Tutorial.

alpha = 1.1e10;
beta = 1e-12;
gamma = 1.25;
delta = 1;
lambda = 10;
mu = 4e-8;
omega = 2.43; 

ylag = Z(:,1);
yp = zeros(2,1);
yp(1) = alpha/(1 + beta*ylag(1)^gamma) - ...
        lambda*y(1)/(1 + mu*y(2)^delta);
yp(2) = lambda*y(1)/(1 + mu*y(2)^delta) - omega*y(2);
