cd('C:\Users\h-philamore\Google Drive\Experiment - Combined power and actuation\circuits\experiment yr 3\actuation_tests_10_2014\plot scripts')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ACTUATION TEST PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% X AND Y AXIS LABELS FOR EACH FIGURE IN THE QUEUE

file{1}='maxon_pic_hbridge_geared_17_10_2014_20_25';
file{2}='maxon_pic_hbridge_geared_17_10_2014_20_11';
file{3}='maxon_direct_drive_geared_17_10_2014_19_58';
file{4}='maxon_direct_drive_geared_17_10_2014_19_43';
%file{5}='maxon_pic_hbridge_17_10_2014_19_07';
%file{6}='maxon_pic_hbridge_17_10_2014_18_58';
file{7}='escap_pic_hbridge_geared_17_10_2014_18_44';
file{8}='escap_pic_hbridge_geared_17_10_2014_18_32';
file{9}='escap_direct_drive_geared_17_10_2014_16_43';
file{10}='escap_direct_drive_geared_17_10_2014_15_58';
%file{11}='escap_pic_hbridge_17_10_2014_14_23_05';
%file{12}='escap_pic_h_bridge_17_10_2014_14_10';
file{13}='ipmc_pic_hbridge_03_11_2014_12_16_shunt';
file{14}='ipmc_pic_hbridge_03_11_2014_12_22_shunt';
file{15}='ipmc_pic_hbridge_03_11_2014_12_28_no_shunt';
file{16}='ipmc_pic_hbridge_03_11_2014_12_40_no_shunt';
file{17}='ipmc_pic_hbridge_03_11_2014_12_51_no_shunt';
file{18}='ipmc_pic_hbridge_03_11_2014_13_12_shunt';
file{19}='sma_direct_drive_03_11_2014_13_50_no_shunt';
file{20}='sma_direct_drive_03_11_2014_14_04_shunt_1_ohm_stretched_3cm';
file{21}='sma_direct_drive_03_11_2014_14_15_shunt_1_ohm_unstretched';
file{22}='sma_direct_drive_03_11_2014_14_20_shunt_1_ohm_unstretched';
file{23}='sma_direct_drive_03_11_2014_14_37_shunt_0,25_ohm_unstretched';
file{24}='sma_direct_drive_03_11_2014_14_41_shunt_0,25_ohm_unstretched';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GLOBAL FILE PATH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fnam = 'C:\Users\h-philamore\Google Drive\Experiment - Combined power and actuation\circuits\experiment yr 3\actuation_tests_10_2014\data_for_plotting';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GLOBAL VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sampling_freq = 50 						%Hz
time_step = 1/ sampling_freq   			%% s

capacitance = 1/3 						% capacitance, supply capacitor, F
%V_cap = 5.5																			% voltage, V
	
resistance_shunt = 1 						% resistnace ohms

gain = 50								% gain on amplified shunt resister

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=[2]
%for i=[19:24]
%for i=[1:4, 7:10, 13:24]

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	%% IMPORT EXCEL DATA
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	filename = [file{i}, '.xlsx']
	
    %time = xlsread(fullfile(fnam, filename),1, 'A:A'); 
    
	laser = xlsread(fullfile(fnam, filename),1, 'B:B'); 
	shunt_amplified = xlsread(fullfile(fnam, filename),2, 'B:B'); 
	motor = xlsread(fullfile(fnam, filename),3, 'B:B'); 
	shunt_and_motor = xlsread(fullfile(fnam, filename),4, 'B:B'); 
	switch_and_light = xlsread(fullfile(fnam, filename),5, 'B:B'); 
	volt_cap = xlsread(fullfile(fnam, filename),6, 'B:B'); 
	shunt = xlsread(fullfile(fnam, filename),7, 'B:B'); 
    shunt = xlsread(fullfile(fnam, filename),7, 'B:B'); 
    
    laser =  laser(11:end);                             % voltage output, laser displacement sensor
	shunt_amplified = shunt_amplified(11:end);          % voltage across shunt resister w/ op amp 
	motor = motor(11:end);                              % voltage across motor
	shunt_and_motor = shunt_and_motor(11:end);          % voltage across motor and shunt resister
	switch_and_light = switch_and_light(11:end);        % voltage of relay that connect experiment to supply capacitor and light that shows period over which power is supplied in video footage
	volt_cap = volt_cap(11:end);                        % supply capacitor voltage
	shunt = shunt(11:end);                              % voltage across shunt resister (unamplified)
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% CREATE TIME ARRAY
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	time = [0:time_step:((length(laser)	-1)*time_step)]              										 % time array given by sampling rate 50Hz (array of values at 0.02s intervals)
	time = time'
    
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% TRIM ARRAYS TO LENGTH OF EXPERIMENT
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Use rising and falling edge threshold values to define start and end of experiment
	
% 	switch_and_light_cells = num2cell(switch_and_light)   								% convert array to cell array
% 	
% 	threshold_low = 2 																	% threshold of 1V 
% 	threshold_hi = 4 
% 	switch_indices = find(cellfun(@(x)(x>threshold_low)&&(x<threshold_hi), switch_and_light_cells))   	% array of indices exceeding 1V
% 	
% 	s = switch_indices(1) 																				% indices start of experiment
% 	f = switch_indices(length(switch_indices)) 															% indices end of experiment
        plot(time, volt_cap)
        threshold_rise = 3.5   												% set high threshold
        
        if ~isempty (findstr(filename, 'hbridge'))                          % set high threshold set low threshold depending on circuit
            
                threshold_fall = 1.2
        else 
                threshold_fall = 0.03
        end
        
		offset_volt_cap = [volt_cap(2:end); NaN];                           % Create the offset data.  Need to append a NaN to the final sample since both vectors need to have the same length.
		
		s = find(volt_cap < threshold_rise & offset_volt_cap > threshold_rise);	% Find the indices of rising edges.									
		f = find(volt_cap > threshold_fall & offset_volt_cap < threshold_fall);	% Find the indices of falling edge.
		
        s=s(1)
        f=f(length(f))
		
	% TRIM ARRAYS TO LENGTH OF EXPERIMENT
	
	laser = laser(s:f)   																					
	shunt_amplified = shunt_amplified(s:f)
	motor = motor(s:f) 
	shunt_and_motor = shunt_and_motor(s:f)
	switch_and_light = switch_and_light(s:f)
	volt_cap = volt_cap(s:f)
	shunt = shunt(s:f) 
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% CREATE TIME ARRAY
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	time = [0:time_step:((length(laser)	-1)*time_step)]              										 % time array given by sampling rate 50Hz (array of values at 0.02s intervals)
	time = time'
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% FIND CAP INITIAL VOLTAGE
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	V_cap = volt_cap(2)
    V_cap_str = ['Capacitor voltage=', num2str(V_cap), 'V']
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% CALCULATE CURRENT (FROM RESISTER/ FROM CAP DISCHARGE) , POWER ,  ENERGY
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%% Calculate current from analogue voltages 	
	current_shunt_amp = shunt_amplified / (resistance_shunt * gain)              								% converts voltage across shunt resistor to current (A)
	current_shunt = shunt / resistance_shunt
	displacement = laser 																% converts voltage to displacement (mm)
	%displacement = displacement - displacement(1) 										% normalises displacement to displacament from point 0
	
	
	%% Calculate current and displacement values from cap discharge 
	current_cap = zeros(length(time),1);                                            		% create matrix to hold values (dimensions R, C)
	current_cap(1,:) = 0;  																% first value = 0
	
	for k = [2:length(time)]  		
		current_c = capacitance * (volt_cap(k-1)-volt_cap(k))/(time(k)-time(k-1))		    % calculate current
		current_cap(k,:) = current_c; 																% append array of values
    end	
    
    %current_cap(1,:) = current_cap(2,:);
	
		% % Low pass noise filter on current of motor/ipmc: zero_phase_filter(window, signal_to_filter)
        
        if ~isempty(findstr(filename,'maxon'))|~isempty(findstr(filename,'escap'))
            
			avg_current_shunt = zero_phase_filter(250, current_shunt)					% filter values
            avg_current_shunt_amp = zero_phase_filter(50, current_shunt_amp)	
            avg_current_cap = zero_phase_filter(250, current_cap)	
            
        else
            
            avg_current_shunt = zero_phase_filter(2, current_shunt)					% filter values
            avg_current_shunt_amp = zero_phase_filter(2, current_shunt_amp)	
            avg_current_cap = zero_phase_filter(2, current_cap)	
		end
		
	
	%% Calculate motor power from current and voltage
	motor_power = zeros(length(time),1);                                            							% create matrix to hold values (dimensions R, C)
	motor_power(1,:) = 0;  
    
	for k = [2:length(time)]  		
		p = motor(k) * avg_current_shunt_amp(k) 														% calculate power
		motor_power(k,:) = p; 																				% append array of values
    end	
    
    %motor_power(1,:) = motor_power(2,:)
	
	%p_max = max(motor_power) 	% maximum power value to scale graph
    
	
	%% Calculate motor power from current and voltage
	
	cap_discharge_power = zeros(length(time),1);                                            							% create matrix to hold values (dimensions R, C)
		
	for k = [1:length(time)]  		
		p = volt_cap(k) * avg_current_cap(k) 														% calculate power
		cap_discharge_power(k,:) = p; 																				% append array of values
	end		
	
	%Calculate power efficiency (dynamic efficiency)
	absolute_motor_power= abs(motor_power)
	
    p_max = max(absolute_motor_power) 	% maximum power value to scale graph
    
    % power_transfer_efficiency = zeros(length(time), 1);
		  % for k=[1:length(time)]
			  % p= absolute_motor_power(k)/cap_discharge_power(k)
			  % power_transfer_efficiency(k,:)=p;
		  % end
	
	 % power_transfer_efficiency = motor_power/cap_discharge_power
	 
	% avg_power_transfer_efficiency = mean(power_transfer_efficiency)
	% std_power_transfer_efficiency = std(power_transfer_efficiency)
	% avg_power_transfer_efficiency_str = ['mean power transfer efficiency=', num2str(std_power_transfer_efficiency), '(\Omega)']
	% std_power_transfer_efficiency_str = ['(standard deviation=', num2str(std_power_transfer_efficiency),')']
	
	%% Calculate energy 
	%%absolute_power= abs(motor_power)
	energy_motor = sum(absolute_motor_power(2:end))*time_step																		% energy used by motor, J (sum(power)*timestep)
	motor_efficiency = energy_motor / (0.5 * capacitance * (V_cap)^2)
	
	energy_motor = round(energy_motor,2)
	motor_efficiency = round(motor_efficiency,2)
	
	energy_str = ['energy=', num2str(energy_motor), '(J)']
	efficiency_str = ['mechanical efficiency=', num2str(motor_efficiency)]
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Calculate energy required by control system to size capacitor
     power_pic = zeros(length(avg_current_cap), 1)
%     
    for q = [1:length(time)]  		
		p = (avg_current_cap(q) - avg_current_shunt_amp(q))			* 	volt_cap(q)										% calculate power
		power_pic(q,:) = p; 																				% append array of values
	end	

    energy_pic = sum(power_pic)* time_step   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 	

	% Calculate R_total
	resistance_shunt_array = ones(length(time), 1)*resistance_shunt
	resistance_total = zeros(length(time),1)
	
	for k = [1:length(time)]  		
		p = (resistance_shunt_array(k)) * (shunt_and_motor(k)/shunt(k))														% calculate power
		resistance_total(k,:) = p; 																				% append array of values
	end	

	% Calculate R_motor
	resistance_motor = zeros(length(time),1)
		
	for k = [1:length(time)]  		
		p = resistance_total(k)*(motor(k) / shunt_and_motor(k))	% calculate resistance
        p = abs(p)                                              % give as unsigned value
		resistance_motor(k,:) = p; 																				% append array of values
    end
    
    % If motor/ipmc find average resistance
    
    if ~isempty(findstr(filename,'maxon'))|~isempty(findstr(filename,'escap')) |~isempty(findstr(filename,'ipmc'))
            
			 avg_resistance_motor = zero_phase_filter(300, resistance_motor)
            
        else
        
            avg_resistance_motor = zero_phase_filter(3, resistance_motor)
	end
    
    %avg_resistance_motor = zero_phase_filter(300, resistance_motor)
   
    
    hold on
        plot(time, resistance_motor)
        plot(time, avg_resistance_motor);
      
		%plot(time, avg_resistance_motor);
		
		a=gcf
		%%set(y,'FontWeight', 'bold')	
		set(a,'PaperOrientation','landscape');
		set(a,'PaperUnits','normalized');
		set(a,'PaperPosition', [0 0 1 1]);
		fname = 'C:\Users\h-philamore\Google Drive\Experiment - Combined power and actuation\circuits\experiment yr 3\actuation_tests_10_2014\motor_resistance'
		filename = [file{i}, '.jpeg']
		saveas(a, fullfile(fname, filename));
		filename = [file{i}, '.fig']
		saveas(a, fullfile(fname, filename));
		filename = [file{i}, '.pdf']
		saveas(a, fullfile(fname, filename));
		
		hold off
		clf
    
    
	mean_resistance_motor = mean(avg_resistance_motor)
	std_resistance_motor = std(avg_resistance_motor)
	avg_resistance_motor_str = ['mean motor resistance=', num2str(mean_resistance_motor), '(\Omega)']
	std_resistance_motor_str = ['(standard deviation=', num2str(std_resistance_motor),')']
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% MAIN PROGRAM : PLOT ELECTRICAL CHARACTERISTICS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	
	%% QUEUE OF VALUES TO BE PLOTTED
	
	electrical_characteristics_ax1 = [volt_cap, motor, shunt_and_motor]
	%, resistance_motor] 
	%power_transfer_efficiency ]
	
	x_label_1 =['Time (s)']
	y_label_1 =['Voltage (V)']
	legend_1{1} = 'Capacitor V';  
	legend_1{2} ='Motor V';
	legend_1{3} = 'Shunt and motor V';
% 	%legend_1{4} = 'Power Transfer Efficiency';
	electrical_characteristics_ax2 = [avg_current_shunt_amp, motor_power]
	x_label_2 =['Time (s)']
	y_label_2 =['Current (A), Power(W)']
	legend_2{1} = 'Current';
	legend_2{2} = 'Motor Power';
	
	
	plot_electrical_characteristics
	 
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% MAIN PROGRAM : CALCULATE MECHANICAL PARAMETERS - NOTE: FOR MOTOR, USE ENCODER TRIM FUNCTION ON ANY VARIABLE TO BE PLOTTED AGAINST TIME
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%if ~isempty(regexp(filename,'maxon'))
    if ~isempty(findstr(filename,'maxon'))|~isempty(findstr(filename,'escap'))
	%if i<= 16   %% MOTOR
	
		%% VARIABLES
	
		minDuration = 0.02;  					%% minimum pulse duration  (minimum accurate sample is half sample freq (double time_step)
		threshold = -1   						%% threshold voltage to mark rising/falling edge
		encoder_inc = 4       					%% increments on encoder wheel 
		efficiency_motor = 0.6                  %% motor efficiency from data sheet
		
		%% FUNCTION/SCRIPT
		%motor_mechanical(time, displacement, motor_power, minDuration, threshold, encoder_inc, efficiency_motor)
		motor_mechanical
		
	end
			
			
		
	if ~isempty(findstr(filename,'ipmc'))| ~isempty(findstr(filename,'sma')) %SMA & IPMC
		
		%% VARIABLES
		gravity = 9810 								%% mms^-2
		mass = 	0.003								%% mass of weight + crimp (kg)
		
		%% FUNCTION/SCRIPT
		%sma_ipmc_mechanical(time, displacement, mass, gravity);
		sma_ipmc_mechanical
	
	end		
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% MAIN PROGRAM : PLOT MECHANICAL CHARACTERISTICS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%% PLOT POWER AND CAP VOLTAGE VS DISPLACEMENT AND TORQUE
	
	%% QUEUE OF VALUES TO BE PLOTTED
	
	if ~isempty(findstr(filename,'maxon'))|~isempty(findstr(filename,'escap'))  %% MOTOR
	
		%mechanical_characteristics_ax1 = [motor_power_mW(:,1), angular_velocity(:,1), torque(:,1)]
        mechanical_characteristics_ax1 = [motor(:,1), angular_velocity(:,1), torque(:,1)]
		x_label_1 =['Time (s)']
		y_label_1 =['Motor (V), Angular Velocity(rads/s), Torque(mNm)(at 60% motor efficiency)']
		legend_1{1}= 'Motor Voltage';
		legend_1{2}= 'Angular Velocity';
		legend_1{3}= 'Torque';
		mechanical_characteristics_ax2 = [number_rotations(:,1)]
		x_label_2 =['Time (s)']
		y_label_2 =['Rotations']
		legend_2{1} = 'Displacement (rotations)';
	
		elseif ~isempty(findstr(filename,'ipmc')) %%IPMC
            
            displacement = displacement - displacement(1);                  % normalise displacement vector
            
			mechanical_characteristics_ax1 = [motor, velocity, displacement]
			x_label_1 =['Time (s)']
			y_label_1 =['Motor (V), Velocity(mm/s), Displacmemt (mm)']
			legend_1{1}= 'Motor Voltage';
			legend_1{2}= 'Velocity';
			legend_1{3}= 'Displacement';
% 			mechanical_characteristics_ax2 = [displacement]
% 			x_label_2 =['Time (s)']
% 			y_label_2 =['Displacmemt (mm) ']
% 			legend_2{1} = 'Displacement'
			
			else %% SMA
                
                %displacement =  displacement(1) - displacement;             % normalise displacement vector
                
                motor = abs(motor)                                          % motor voltage non-polarised
                
				mechanical_characteristics_ax1 = [motor, velocity,displacement]
				x_label_1 =['Time (s)']
				y_label_1 =['Motor (V), Velocity(mm/s), Displacmemt (mm) ']
				legend_1{1}= 'Motor Voltage';
				legend_1{2}= 'Velocity';
				legend_1{3}= 'Displacement';
                %legend_1{4}= 'acceleration';
                mechanical_characteristics_ax2 = [force]
				x_label_2 =['Time (s)']
				y_label_2 =['Force(mN)']
				legend_2{1} = 'Force';
	end

	plot_mechanical_characteristics
	
	
end	

		