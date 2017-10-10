function [sol0,sol1] = prob1
%  This system of ODE's is taken from 'An Introduction to Nuermcial Methods
%  for Differential Equations', by J.M. Ortega and W.G. Poole (Reference 13 
%  of the tutorial).  There is additional information about predator-prey 
%  systems in 'Functional Differntial Equations' by J. Hale (Reference 7 of
%  the tutorial).

% Copyright 2004, The MathWorks, Inc.

  history = [80; 30];
  tspan = [0, 100];
  opts = ddeset('RelTol',1e-5,'AbsTol',1e-8);

  % Known parameters, visible in nested functions.
  a =  0.25;
  b = -0.01;
  c = -1.00;
  d =  0.01;

  % Solve the ODEs that arise when there is no delay.
  sol0 = dde23(@prob1f,[],history,tspan,opts);
   
  % Solve the DDEs that arise when there is a delay of tau.
  tau = 1;
  sol1 = dde23(@prob1f,tau,history,tspan,opts);

  figure
  plot(sol0.y(1,:),sol0.y(2,:),sol1.y(1,:),sol1.y(2,:))
  title('Problem 1. Solution with and without delay.')
  xlabel('y_1(t)')
  ylabel('y_2(t)')
  legend('No delay',['Delay \tau = ',num2str(tau)],2)

  %-----------------------------------------------------------------------
  % Nested function
  %

  function v = prob1f(t,y,Z)
  %PROB1F  The derivative function for Problem 1 of the DDE Tutorial.
    v = zeros(2,1);
    if isempty(Z)     % ODEs
      v(1) = a * y(1) + b * y(1) * y(2);
      v(2) = c * y(2) + d * y(1) * y(2);
    else              % DDEs
      m = 200;
      ylag = Z(:,1);
      v(1) = a * y(1) * (1 - y(1) / m) + b * y(1)    * y(2);
      v(2) = c * y(2)                  + d * ylag(1) * ylag(2);
    end
  end % prob1f
  
  %-----------------------------------------------------------------------
  
end  % prob1

