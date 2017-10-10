Ds = Simulink.SimulationData.Dataset (simout); 

% get data values
y = Ds.get (1) .Values.Data;

% get time values
t = Ds.get (1) .Values.Time;

% return step resonse characteristics
S = stepinfo(y,t)