function sol = exam6
% This is a demonstration problem for CTMS/BD in 
% L. Tavernini, Continuous--Time Modeling and 
% Simulation, Gordon and Breach, Amsterdam, 1996.  
% It illustrates how to deal with the unusual
% situation of a solution discontinuous at the 
% initial point. Tavernini uses an initial y of 
% 19.00001, but we use 19.001 so as to see the 
% cyclic behavior sooner.

% Copyright 2004, The MathWorks, Inc.

  % Known parameters, visible in nested functions.
  r = 3.5;
  m = 19;

  options = ddeset('RelTol',1e-4,'AbsTol',1e-7,...
                   'InitialY',19.001);
  sol = dde23(@exam6f,0.74,19,[0, 40],options);
  figure
  plot(sol.x,sol.y);
  title('Population of Lemmings--Time Series')
  xlabel('time t');
  ylabel('y(t)');
  figure
  plot(sol.y,sol.yp)
  title('Population of Lemmings--Phase Plane')
  xlabel('y(t)');
  ylabel('y''(t)');
  
  %-----------------------------------------------------------------------
  % Nested function
  %
  
  function yp = exam6f(t,y,Z)
  %EXAM6F  The derivative function for the Example 6 of the DDE Tutorial.
    yp = r*y*(1 - Z/m);
  end % exam6f

  %-----------------------------------------------------------------------
    
end  % exam6  
