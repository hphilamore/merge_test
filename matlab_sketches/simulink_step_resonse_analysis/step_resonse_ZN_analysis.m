Ds = Simulink.SimulationData.Dataset (simout); 

% get data values
y = Ds.get (1) .Values.Data;

% get time values
t = Ds.get (1) .Values.Time;

% uncomment when step input starts after time zero starts after
% [y, index]= unique(y);                                          % remove duplicate data values
% t = t(index);                                                   % find corresponding time values
%t = t - t(2);                                                   % set start time to zero

% INPUT
% the time of the change in set point or disturbance (if there is no change
% after the step response set this to zero 
T = 20

loc = t>T ;                                                % time zero = time of disturbance
t = t(loc);                                                   % trim time data   
y = y(loc);                                                      % trim resonse data 

% INPUT
% if set point change, enter new set point.
% if disturbance, set point = y(1)
%SP = 1
SP = y(1)
  
t = t - t(1);                                                    % set initial values to 0
SP = SP - y(1);
y = y - y(1);
S = sign(y(end) - y(1));                                        % find the direction of the step
y = S * y                                                      % reorganise step data for analysis

d1y = gradient(y,t);                                            % Numerical Derivative
d2y = del2(y,t);                                                % Numerical Second Derivative
t_infl = interp1(d1y, t, max(d1y));                             % Find ?t? At Maximum Of First Derivative
y_infl = interp1(t, y, t_infl);                                 % Find ?y? At Maximum Of First Derivative
slope  = interp1(t, d1y, t_infl);                               % Slope Defined Here As Maximum Of First Derivative
intcpt = y_infl - slope*t_infl;                                 % Calculate Intercept
tngt = slope*t + intcpt;                                        % Calculate Tangent Line
figure(1)
plot(t, y)
hold on
plot(t, d1y, '-.m',    t, d2y, '--c')                           % Plot Derivatives (Optional)
plot(t, tngt, '-r', 'LineWidth',1)                              % Plot Tangent Line
plot(t_infl, y_infl, 'bp')                                      % Plot Maximum Slope
hold off
grid
legend('y(t)', 'dy/dt', 'd^2y/dt^2', 'Tangent', 'Location','E')
axis([xlim    min(min(y),intcpt)  ceil(max(y))])
K = max(y);
L = -intcpt/slope
T = (K-intcpt)/slope - L

% return step resonse characteristics
sserror=abs(SP-y(end))

S = stepinfo(y,t)
