Ds = Simulink.SimulationData.Dataset (simout); 

% get data values
y = Ds.get (1) .Values.Data;

% get time values
t = Ds.get (1) .Values.Time;

[y, index]= unique(y);                                          % remove duplicate data values
t = t(index);                                                   % find corresponding time values
t = t - t(2);                                                   % set start time to zero
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
