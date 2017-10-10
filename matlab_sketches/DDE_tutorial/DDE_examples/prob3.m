function sol = prob3
%  This problem is epidemic model due to Cooke, more information can be
%  found in 'Time lags in Biological Models', by N. MacDonald.  (This is
%  reference 8 of the tutorial).

% Copyright 2002, The MathWorks, Inc.

b = 2;
c = 1;
e = 1 - c/b;   % Equilibrium point.

sol = dde23(@prob3f,7,0.8,[0, 60],[],b,c);

figure
plot(sol.x,sol.y,[0, 60],[e, e],'r')
legend('y(t)','1 - c/b')
title(['Problem 3. Cooke Epidemic Model with' ...
       ' b = ',num2str(b),' , c = ',num2str(c),'.'])
xlabel('time t')

%-----------------------------------------------------------------------

function yp = prob3f(t,y,Z,b,c)
%PROB3F  The derivative function for Problem 3 of the DDE Tutorial.
yp = b * Z * (1 - y) - c * y;
