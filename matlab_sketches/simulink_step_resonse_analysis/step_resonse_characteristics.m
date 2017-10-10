Ds = Simulink.SimulationData.Dataset (simout); 

% get data values
y = Ds.get (1) .Values.Data;

% get time values
t = Ds.get (1) .Values.Time;

% return step resonse characteristics
sserror=abs(SP-y(end))

S = stepinfo(y,t)

% S = stepinfo(y,t, 3)
%SP = 3

