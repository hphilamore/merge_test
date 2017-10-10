function [sol1,sol2,sol3,sol4] = exam3
% Example 4.2 of H.J. Oberle and H.J. Pesch, Numerical 
% treatment of delay differential equations by Hermite 
% interpolation, Numer. Math., 37 (1981) 235-255.  This 
% problem is solved for four values of a parameter lambda.  
% Oberle and Pesch point out that the problem is numerically 
% more sensitive for the larger values of lambda, so they
% are solved with more stringent tolerances.

% Copyright 2004, The MathWorks, Inc.

  % Known parameter, visible in nested functions.
  lambda = 1.5;
  
  sol1 = dde23(@exam3f,1,@exam3h,[0, 20]);
  figure
  plot(sol1.x,sol1.y,'b')
  axis([0 20 -1 7]), drawnow, hold on
  
  lambda = 2.0;
  % After re-creating function handles, the new value 
  % of lambda will be used in nested functions.
  sol2 = dde23(@exam3f,1,@exam3h,[0, 20]);
  plot(sol2.x,sol2.y,'g'), drawnow
  
  lambda = 2.5;
  opts = ddeset('RelTol',1e-5,'AbsTol',1e-8);
  sol3 = dde23(@exam3f,1,@exam3h,[0, 20],opts);
  plot(sol3.x,sol3.y,'r'), drawnow

  lambda = 3.0;
  opts = ddeset('RelTol',1e-6,'AbsTol',1e-10);
  sol4 = dde23(@exam3f,1,@exam3h,[0, 20],opts);
  plot(sol4.x,sol4.y,'k'), drawnow
  
  legend('\lambda = 1.5','\lambda = 2.0',...
         '\lambda = 2.5','\lambda = 3.0')
  title('Example 4.2 of Oberle and Pesch.')
  hold off
  
  %-----------------------------------------------------------------------
  % Nested functions
  %

  function yp = exam3f(t,y,Z)
  %EXAM3F  The derivative function for the Example 3 of the DDE Tutorial.
    yp = -lambda*Z*(1 + y);   
  end % exam3f
  
  %-----------------------------------------------------------------------

  function y = exam3h(t)
  %EXAM3H  The history function for the Example 3 of the DDE Tutorial.
    y = t;
  end  % exam3h  

  %-----------------------------------------------------------------------

end  % exam3  
