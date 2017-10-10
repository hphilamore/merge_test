
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% motor_mechanical : CALC ROTATIONS, ANGULAR SPEED, AND TORQUE OR MOTOR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%function[time_encoder_rotations, motor_power_mW, number_rotations, angular_velocity, torque] = motor_mechanical(time, displacement, motor_power, minDuration, threshold, encoder_inc, efficiency_motor)
%function time_encoder_rotations = motor_mechanical(time, displacement, motor_power, minDuration, threshold, encoder_inc, efficiency_motor)

		plot(time, displacement)
		hold on 
		%threshold = -1   												% set threshold to 0 V
		offsetdisplacement = [displacement(2:end); NaN]; 				% Create the offset data.  Need to append a NaN to the final sample since both vectors need to have the same length.
		
		risingEdge = find(displacement < threshold & offsetdisplacement > threshold);	% Find the indices of rising edges.									
		fallingEdge = find(displacement > threshold & offsetdisplacement < threshold);	% Find the indices of falling edge.
		
		time_rising_edge = time(risingEdge); 											% array of time of rising edges				
		time_falling_edge = time(fallingEdge) 											% array of time of falling edges	
		
		lengthEdge = sum([length(risingEdge) length(fallingEdge)])
		pulseIndices = zeros(lengthEdge, 1); 								% Construct a vector to hold all of the times.
		
		if time_rising_edge(1) > time_falling_edge(1)
				pulseIndices(1:2:end) = fallingEdge;
				pulseIndices(2:2:end) = risingEdge;
		end	
			
		if time_rising_edge(1) < time_falling_edge(1)
					pulseIndices(1:2:end) = risingEdge;
					pulseIndices(2:2:end) = fallingEdge;
				
		end	
		pulseTimes = diff(time(pulseIndices)) 											% Compute the pulse durations.
		
		filtered_displacement = displacement;   										% Create a variable for the processed data.
		
		pulsesToRemove = find(pulseTimes < minDuration);								% Find the pulses that are less than 50 ms.
		
		for y = 1:length(pulsesToRemove);
			startInd = pulseIndices(pulsesToRemove(y));
			endInd = pulseIndices(pulsesToRemove(y)+1);
			%filtered_displacement(startInd:endInd) = 0; 										% Remove the pulses that are too short by setting their value to 0 V.
            filtered_displacement(startInd:endInd) = threshold;
            %angular_velocity(1) = 0; 
            
        end

		plot(time, filtered_displacement) 														% Plot the filtered data and repeat threshold analysis
		
		hold on 
		%threshold = -1                                                                                             % set threshold to 0 V
		offset_filtered_displacement = [filtered_displacement(2:end); NaN]; 										% Create the offset data.  Need to append a NaN to the final sample since both vectors need to have the same length.
		
		risingEdge = find(filtered_displacement < threshold & offset_filtered_displacement > threshold);			% Find the indices of rising edges.									
					
		time_rising_edge = time(risingEdge) 																		% array of time of rising edges			

		% Show the rising edges with red x's.
		hold on
		plot(time_rising_edge, threshold, 'rx');
		
		a=gcf
		%%set(y,'FontWeight', 'bold')	
		set(a,'PaperOrientation','landscape');
		set(a,'PaperUnits','normalized');
		set(a,'PaperPosition', [0 0 1 1]);
		fname = 'C:\Users\h-philamore\Google Drive\Experiment - Combined power and actuation\circuits\experiment yr 3\actuation_tests_10_2014\actuation_test_encoder'
		filename = [file{i}, '.jpeg']
		saveas(a, fullfile(fname, filename));
		filename = [file{i}, '.fig']
		saveas(a, fullfile(fname, filename));
		filename = [file{i}, '.pdf']
		saveas(a, fullfile(fname, filename));
		
		hold off
		clf
		
		%time_encoder_rotations = [0;time_rising_edge(encoder_inc:encoder_inc:end)]; 								% time of every 4th rising edge (time of each rotation)
		angle = [0: pi/2: (length(time_rising_edge)-1)* (pi/2)]     						    % create an array of angle for each rotation of encoder
		number_rotations = [0: 1: length(time_rising_edge)-1] 							% create an array of rotations for each rotation of encoder
        number_rotations = number_rotations * 0.25
		number_rotations=number_rotations'
        
        
        angular_velocity = zeros((length(time_rising_edge)),1);                                           	% create matrix to hold values (dimensions R, C)
		%angular_velocity(1) = 0; 
        angular_velocity(1) = 0; % angular velocity at time 0 = 0
		
		
       for y=[2:(length(time_rising_edge)-1)]
			 dTheta = angle(y)-angle(y-1)
			 dTime = time_rising_edge(y)-time_rising_edge(y-1)
			 omega = dTheta/dTime																				% find angular velocity from position differential
			 angular_velocity(y,:) = omega; 																		% append array of values
		 end		
		
		%% Divide power by velocity to get torque			
		%efficiency_motor = 0.6 																	% motor efficiency from data sheet
		
		torque = zeros((length(time_rising_edge)),1);    		% create matrix to hold values (dimensions R, C)
        
		torque(1) = 0; % angular velocity at time 0 = 0
        
		motor_power_mW = motor_power*10^3
		% motor_power_mW = motor_power_mW(risingEdge) 											% trim motor power values to give those at rising edges
		% motor_power_mW= [0;motor_power_mW(encoder_inc:encoder_inc:end)]; 	
		motor_power_mW = encoder_filter(risingEdge, encoder_inc, motor_power_mW)
        motor = encoder_filter(risingEdge, encoder_inc, motor)
        
					
		for y=[2:(length(time_rising_edge)-1)]
			T = (efficiency_motor*motor_power_mW(y))/angular_velocity(y)   										% torque in mNm at motor eff= 60%
			%T = T*10^3 																						% torque uW	
			torque(y,:) = T; 																					% append array of values
		end	
		
		angular_velocity= zero_phase_filter(20, angular_velocity)		
		torque = zero_phase_filter(20, torque)	
        
       
        
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
        
% %         %encoder_inc = 4 														        	     			% number of increments on encoder wheel
% % 		time_encoder_rotations = [0;time_rising_edge(encoder_inc:encoder_inc:end)]; 								% time of every 4th rising edge (time of each rotation)
%  		angle = [0: 2*pi: (length(time_encoder_rotations)-1)*2*pi]     						    % create an array of angle for each rotation of encoder
%  		number_rotations = [0: 1: length(time_encoder_rotations)-1] 							% create an array of rotations for each rotation of encoder
%  		number_rotations=number_rotations'
% 		
% 			
% 		%% Calculate angular velocity - Differentiate position to find angular velocity	
% 		
% 		angular_velocity = zeros((length(time_encoder_rotations)),1);                                           	% create matrix to hold values (dimensions R, C)
% 		%angular_velocity(1) = 0; 
%         angular_velocity(1) = NaN; % angular velocity at time 0 = 0
% 		
% 		for y=[2:(length(time_encoder_rotations)-1)]
% 			 dTheta = angle(y)-angle(y-1)
% 			 dTime = time_encoder_rotations(y)-time_encoder_rotations(y-1)
% 			 omega = dTheta/dTime																				% find angular velocity from position differential
% 			 angular_velocity(y,:) = omega; 																		% append array of values
% 		 end		
% 		
% 		
% 		% for y=[1:(length(time_encoder_rotations)-1)]
% 			% dTheta = diff(angle)
% 			% dTime = diff(time_encoder_rotations)
% 			% omega = dTheta(y)/dTime(y) 																				% find angular velocity from position differential
% 			% angular_velocity(y,:) = omega; 																		% append array of values
% 		% end		
% 		
% 		%% Divide power by velocity to get torque			
% 		%efficiency_motor = 0.6 																	% motor efficiency from data sheet
% 		
% 		torque = zeros((length(time_encoder_rotations)),1);    		% create matrix to hold values (dimensions R, C)
% 		
% 		motor_power_mW = motor_power*10^3
% 		% motor_power_mW = motor_power_mW(risingEdge) 											% trim motor power values to give those at rising edges
% 		% motor_power_mW= [0;motor_power_mW(encoder_inc:encoder_inc:end)]; 	
% 		motor_power_mW = encoder_filter(risingEdge, encoder_inc, motor_power_mW)
% 					
% 		for y=[1:(length(time_encoder_rotations)-1)]
% 			T = (efficiency_motor*motor_power_mW(y))/angular_velocity(y)   										% torque in mNm at motor eff= 60%
% 			%T = T*10^3 																						% torque uW	
% 			torque(y,:) = T; 																					% append array of values
% 		end	
% 		
% 		angular_velocity = zero_phase_filter(100, angular_velocity)		
% 		torque = zero_phase_filter(100, torque)	
% 		
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
		
% 		% for y=[1:(length(time_encoder_rotations)-1)]
% 			% dTheta = diff(angle)
% 			% dTime = diff(time_encoder_rotations)
% 			% omega = dTheta(y)/dTime(y) 																				% find angular velocity from position differential
% 			% angular_velocity(y,:) = omega; 																		% append array of values
% 		% end		
% 		
% 		%% Divide power by velocity to get torque			
% 		%efficiency_motor = 0.6 																	% motor efficiency from data sheet
% 		
% 		torque = zeros((length(time_encoder_rotations)),1);    		% create matrix to hold values (dimensions R, C)
% 		
% 		motor_power_mW = motor_power*10^3
% 		% motor_power_mW = motor_power_mW(risingEdge) 											% trim motor power values to give those at rising edges
% 		% motor_power_mW= [0;motor_power_mW(encoder_inc:encoder_inc:end)]; 	
% 		motor_power_mW = encoder_filter(risingEdge, encoder_inc, motor_power_mW)
% 					
% 		for y=[1:(length(time_encoder_rotations)-1)]
% 			T = (efficiency_motor*motor_power_mW(y))/angular_velocity(y)   										% torque in mNm at motor eff= 60%
% 			%T = T*10^3 																						% torque uW	
% 			torque(y,:) = T; 																					% append array of values
% 		end	
% 		
% 		angular_velocity = zero_phase_filter(100, angular_velocity)		
% 		torque = zero_phase_filter(100, torque)	
% 		
%         
%            
%         
% %         %encoder_inc = 4 														        	     			% number of increments on encoder wheel
% % 		time_encoder_rotations = [0;time_rising_edge(encoder_inc:encoder_inc:end)]; 								% time of every 4th rising edge (time of each rotation)
% % 		angle = [0: 2*pi: (length(time_encoder_rotations)-1)*2*pi]     						    % create an array of angle for each rotation of encoder
% % 		number_rotations = [0: 1: length(time_encoder_rotations)-1] 							% create an array of rotations for each rotation of encoder
% % 		number_rotations=number_rotations'
% 		
% 			
% 		%% Calculate angular velocity - Differentiate position to find angular velocity	
% 		
% 		angular_velocity = zeros((length(time_encoder_rotations)),1);                                           	% create matrix to hold values (dimensions R, C)
% 		%angular_velocity(1) = 0; 
%         angular_velocity(1) = NaN; % angular velocity at time 0 = 0
% 		
% 		for y=[2:(length(time_encoder_rotations)-1)]
% 			 dTheta = angle(y)-angle(y-1)
% 			 dTime = time_encoder_rotations(y)-time_encoder_rotations(y-1)
% 			 omega = dTheta/dTime																				% find angular velocity from position differential
% 			 angular_velocity(y,:) = omega; 																		% append array of values
% 		 end		
% 		
% 		
% 		% for y=[1:(length(time_encoder_rotations)-1)]
% 			% dTheta = diff(angle)
% 			% dTime = diff(time_encoder_rotations)
% 			% omega = dTheta(y)/dTime(y) 																				% find angular velocity from position differential
% 			% angular_velocity(y,:) = omega; 																		% append array of values
% 		% end		
% 		
% 		%% Divide power by velocity to get torque			
% 		%efficiency_motor = 0.6 																	% motor efficiency from data sheet
% 		
% 		torque = zeros((length(time_encoder_rotations)),1);    		% create matrix to hold values (dimensions R, C)
% 		
% 		motor_power_mW = motor_power*10^3
% 		% motor_power_mW = motor_power_mW(risingEdge) 											% trim motor power values to give those at rising edges
% 		% motor_power_mW= [0;motor_power_mW(encoder_inc:encoder_inc:end)]; 	
% 		motor_power_mW = encoder_filter(risingEdge, encoder_inc, motor_power_mW)
% 					
% 		for y=[1:(length(time_encoder_rotations)-1)]
% 			T = (efficiency_motor*motor_power_mW(y))/angular_velocity(y)   										% torque in mNm at motor eff= 60%
% 			%T = T*10^3 																						% torque uW	
% 			torque(y,:) = T; 																					% append array of values
% 		end	
% 		
% 		angular_velocity = zero_phase_filter(100, angular_velocity)		
% 		torque = zero_phase_filter(100, torque)	
% 		