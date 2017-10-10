function sol = exam4
% Infectious disease model of E. Hairer, S.P. Norsett, 
% and G. Wanner, Solving Ordinary Differential Equations 
% I, Springer-Verlag, Berlin, 1987, p. 295.  The maxima 
% of the solution components are located by finding where 
% the first derivative vanishes.  A maximum occurs when 
% the first derivative goes from a positive to a negative 
% value, so we tell DDE23 that we are interested only in 
% zeros for which the function decreases through zero.

% Copyright 2002, The MathWorks, Inc.

options = ddeset('Events',@exam4e);
sol = dde23(@exam4f,[1, 10],[5; 0.1; 1],[0, 40],options);

% Separate the various kinds of events and the solution 
% values then. ie = 1,2,3 according to which component 
% of the solution has a maximum.  Local variables are 
% used for clarity.
xe = sol.xe;
ye = sol.ye;
ie = sol.ie;
n1 = find(ie == 1);
x1 = xe(n1);
y1 = ye(1,n1);
n2 = find(ie == 2);
x2 = xe(n2);
y2 = ye(2,n2);
n3 = find(ie == 3);
x3 = xe(n3);
y3 = ye(3,n3);

figure
plot(sol.x,sol.y,'k',x1,y1,'rs',x2,y2,'rs',x3,y3,'rs')
title('Infectious disease model from Hairer et alia.')
xlabel('Maxima are indicated by red squares.')

%-----------------------------------------------------------------------

function yp = exam4f(x,y,Z)
%EXAM4F  The derivative function for the Example 4 of the DDE Tutorial.
ylag1 = Z(:,1);
ylag2 = Z(:,2);
yp = [ -y(1)*ylag1(2) + ylag2(2)
        y(1)*ylag1(2) - y(2)
        y(2) - ylag2(2)          ];

%-----------------------------------------------------------------------

function [value,isterminal,direction] = exam4e(x,y,Z)
%EXAM4E  The event function for the Example 4 of the DDE Tutorial.

% Maxima occur where the first derivatives vanish.
value = exam4f(x,y,Z);
isterminal = zeros(3,1);
direction = -ones(3,1);
