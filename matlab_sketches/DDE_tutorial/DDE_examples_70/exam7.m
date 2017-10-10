function sol = exam7
% An example from C. Marriott and C. DeLisle, Effects 
% of discontinuities in the behavior of a delay 
% differential equation, Physica D, 36 (1989), pp. 198-206.

% Copyright 2004, The MathWorks, Inc.

  % Known parameter, visible in nested functions.
  % The parameter state = +1 if ylag >= -0.427, -1 otherwise.  
  % With this definition of history, state is initially +1.
  state = +1;

  opts = ddeset('Events',@exam7e);
  sol = dde23(@exam7f,12,0.6,[0, 120],opts);
  while sol.x(end) < 120
    fprintf('Restart at %5.1f.\n',sol.x(end));
    state = - state;
    % After re-creating function handles, the new value 
    % of state will be used in nested functions.
    sol = dde23(@exam7f,12,sol,[sol.x(end), 120],opts);
  end
  figure
  plot(sol.x,sol.y);
  title('Marriott-DeLisle Controller Problem')
  xlabel('Restart each time y(t - 12) = -0.427.');

  %-----------------------------------------------------------------------
  % Nested functions
  %
  
  function yp = exam7f(t,y,Z)
  %EXAM7F  The derivative function for the Example 7 of the DDE Tutorial.
    xb = -0.427;
    a = 0.16;
    epsilon = 0.02;
    u = 0.5;
    tau = 1;
    Delta = Z - xb;
    yp = (-y + pi*(a + epsilon*state - u*sin(Delta)^2)) / tau;
  end % exam7f
    
  %-----------------------------------------------------------------------

  function [value,isterminal,direction] = exam7e(t,y,Z)
  %EXAM7E  The event function for the Example 7 of the DDE Tutorial.
    xb = -0.427;
    value = Z - xb;
    isterminal = 1;
    direction = 0;
  end % exam7e
  
  %-----------------------------------------------------------------------

end  % exam7


