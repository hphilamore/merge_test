% set simulink simout (to workspace) block, save format to "structure with time"
% run simulink model

% save model output as data set
Ds = Simulink.SimulationData.Dataset (simout); 

% get data values
Ds.get (1) .Values.Data

% get time values
Ds.get (1) .Values.Time

% plot model output
plot(Ds.get (1) .Values.Time , Ds.get (1) .Values.Data);