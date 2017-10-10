function sol = exam8
% This is the suitcase problem from Suherman, et al.,
% Effect of Human Response Time on Rocking Instability 
% of a Two-Wheeled Suitcase, J. of Sound and Vibration, 
% Vol. 207 (5), 1997, 617-625. Event location is used to 
% find when the wheels impact the ground and when the 
% suitcase has fallen over. The parameter values are those
% used to generate Figure 3a in the reference.

% Copyright 2004, The MathWorks, Inc.

  % Known parameter, visible in nested functions.
  state = +1;
  opts = ddeset('RelTol',1e-5,'AbsTol',1e-5,...
                'Events',@exam8e);
  sol = dde23(@exam8f,0.1,[0; 0],[0 12],opts);  
  ref = [4.516757065, 9.751053145, 11.670393497];
  fprintf('\nKind of Event:                 dde23   reference\n');
  event = 0;
  while sol.x(end) < 12
    event = event + 1;
    if sol.ie(end) == 1
      fprintf('A wheel hit the ground.   %10.4f  %10.6f\n',...
              sol.x(end),ref(event));
      state = - state;
      opts = ddeset(opts,'InitialY',[ 0; 0.913*sol.y(2,end)]);
      % After re-creating function handles, the new value 
      % of state will be used in nested functions. 
      sol = dde23(@exam8f,0.1,sol,[sol.x(end) 12],opts);
    else     
      fprintf('The suitcase fell over.   %10.4f  %10.6f\n',...
              sol.x(end),ref(event));
      break;
    end
  end
  figure
  plot(sol.y(1,:),sol.y(2,:))
  title('Suitcase problem.')
  xlabel('\theta(t)')
  ylabel('\theta''(t)')
      
  %-----------------------------------------------------------------------
  % Nested functions
  %
  
  function yp = exam8f(t,y,Z)
  %EXAM8F  The derivative function for the Example 8 of the DDE Tutorial.
    gamma = 0.248;
    beta  = 1;
    A = 0.75;
    omega = 1.37;
    eta = asin(gamma/A);
    ylag = Z(:,1);
    yp = [y(2); 0];
    yp(2) = sin(y(1)) - state*gamma*cos(y(1)) - ...
            beta*ylag(1) + A*sin(omega*t + eta);
  end % exam8f
  
  %-----------------------------------------------------------------------

  function [value,isterminal,direction] = exam8e(t,y,Z)
  %EXAM8E  The event function for the Example 8 of the DDE Tutorial.
    value = [y(1); abs(y(1))-pi/2];
    isterminal = [1; 1];
    direction  = [0; 0];
  end % exam8e
  
  %-----------------------------------------------------------------------

end  % exam8  