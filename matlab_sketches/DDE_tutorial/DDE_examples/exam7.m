function sol = exam7
% An example from C. Marriott and C. DeLisle, Effects 
% of discontinuities in the behavior of a delay 
% differential equation, Physica D, 36 (1989), pp. 198-206.

% Copyright 2002, The MathWorks, Inc.

% The parameter state = +1 if ylag >= -0.427, -1 otherwise.  
% With this definition of history, state is initially +1.
state = +1;

opts = ddeset('Events',@exam7e);
sol = dde23(@exam7f,12,0.6,[0, 120],opts,state);
while sol.x(end) < 120
   fprintf('Restart at %5.1f.\n',sol.x(end));
   state = - state;
   sol = dde23(@exam7f,12,sol,[sol.x(end), 120],opts,state);
end
figure
plot(sol.x,sol.y);
title('Marriott-DeLisle Controller Problem')
xlabel('Restart each time y(t - 12) = -0.427.');

%-----------------------------------------------------------------------

function yp = exam7f(t,y,Z,state)
%EXAM7F  The derivative function for the Example 7 of the DDE Tutorial.
xb = -0.427;
a = 0.16;
epsilon = 0.02;
u = 0.5;
tau = 1;
Delta = Z - xb;
yp = (-y + pi*(a + epsilon*state - u*sin(Delta)^2)) / tau;

%-----------------------------------------------------------------------

function [value,isterminal,direction] = exam7e(t,y,Z,state)
%EXAM7E  The event function for the Example 7 of the DDE Tutorial.
xb = -0.427;
value = Z - xb;
isterminal = 1;
direction = 0;
