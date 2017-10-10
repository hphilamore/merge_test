function sol = prob5
%  This problem population growth model due to Cooke et alia, more information
%  can be found in 'Interaction of maturation delay and nonlinear birth in
%  population and epidemic models' J. Math. Biol., 39 (1999) 332-352.
%  (This is reference 3 of the tutorial).

% Copyright 2002, The MathWorks, Inc.

global a b d d1 T

% The four data sets:
A  = [1 1 1 1];
D  = [1 1 1 1];
D1 = [1 1 0 0];
B  = [20 80 20 80];

% The three delays:
Delays = [0.2 1.0 2.4];

opts = ddeset('RelTol',1e-5,'AbsTol',1e-8);

for set = [2 4]
   a = A(set);
   b = B(set);
   d = D(set);
   d1 = D1(set);
   
   for i = 1:3
      % Note that T is passed as a global variable to
      % prob5f in addition to its direct use as the delay.
      T = Delays(i);   
      sol(i) = dde23(@prob5f,T,3.5,[0, 25],opts);
   end
   
   figure
   plot(sol(1).x,sol(1).y,sol(2).x,sol(2).y,sol(3).x,sol(3).y)
   legend('T = 0.2','T = 1.0','T = 2.4',0)
   xlabel('time t')
   title(['Problem 5. Maturation Delay and Nonlinear' ...
          ' Birth Problem. Data Set ',num2str(set),'.'])
end

%-----------------------------------------------------------------------

function yp = prob5f(t,y,Z)
%PROB5F  The derivative function for Problem 5 of the DDE Tutorial.

global a b d d1 T
yp = b * exp(-a*Z)*Z*exp(-d1*T) - d*y;
