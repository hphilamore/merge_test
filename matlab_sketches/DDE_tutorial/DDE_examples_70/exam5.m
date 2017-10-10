function sol = exam5
% Example 4.4 of H.J. Oberle and H.J. Pesch, Numerical 
% treatment of delay differential equations by Hermite 
% interpolation, Numer. Math., 37 (1981) 235-255.  This 
% is a model for the spread of an infection due to 
% Hoppensteadt and Waltman.  It is interesting because 
% there are discontinuous changes in the equation at known 
% times. Oberle and Pesch solve the problem for several 
% values of the parameter r, namely 0.2, 0.3, 0.4, 0.5.  
% The example is also interesting in that values of the 
% derivative of the solution are required for another 
% function of interest.

% Copyright 2004, The MathWorks, Inc.

  % Known parameter, visible in nested functions.
  r = 0.5;

  c = 1/sqrt(2);
  opts = ddeset('Jumps',[(1-c), 1, (2-c)],...
                'RelTol',1e-5,'AbsTol',1e-8);
  sol = dde23(@exam5f,1,10,[0, 10],opts);
  
  y10 = deval(sol,10);
  fprintf('DDE23 computed     y(10) =%15.11f.\n',y10);
  fprintf('Reference solution y(10) =%15.11f.\n',0.06302089869);
  
  figure
  plot(sol.x,sol.y)
  title(['Hoppensteadt-Waltman model with r = ',...
         num2str(r),'.'])
  xlabel('time t')
  ylabel('y(t)')
  
  Ioft = -(1/r)*(sol.yp ./ sol.y);
  figure
  plot(sol.x,Ioft)
  title(['Hoppensteadt-Waltman model with r = ',...
         num2str(r),'.'])
  xlabel('time t')
  ylabel('I(t)')
  
  %-----------------------------------------------------------------------
  % Nested function
  %

  function yp = exam5f(t,y,Z)
  %EXAM5F  The derivative function for the Example 5 of the DDE Tutorial.
    c = 1/sqrt(2);
    mu = r/10;
    if t <= 1 - c
      yp = -r*y*0.4*(1 - t);
    elseif t <= 1
      yp = -r*y*(0.4*(1 - t) + 10 - exp(mu)*y);
    elseif t <= 2 - c
      yp = -r*y*(10 - exp(mu)*y);
    else
      yp = -r*exp(mu)*y*(Z - y); 
    end
  end % exam5f

  %-----------------------------------------------------------------------

end  % exam5  
