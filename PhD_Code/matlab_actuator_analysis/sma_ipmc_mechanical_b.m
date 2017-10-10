%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sma_ipmc_mechanical : CALC ROTATIONS, ANGULAR SPEED, AND TORQUE FOR SMA/IPMC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%function[velocity, Force] = sma_ipmc_mechanical (time, displacement, mass, gravity)

%% Calculate velocity - Differentiate position to find velocity	

motor_power_mW = motor_power*10^3

		
		displacement = displacement(1) - displacement;		 						   % displacement in mm in +ve direction

		velocity = zeros((length(displacement)),1);                                     % create matrix to hold values (dimensions R, C)
		velocity(1) = 0;                                            					% velocity at time 0 = 0
		
		for y=[2:(length(displacement))]
			dTheta =(displacement(y)-displacement(y-1))
			dTime = (time(y)-time(y-1))
			omega = dTheta/dTime                                                        % find velocity from position differential mms^1
			velocity(y,:) = omega; 														% append array of values
		end		
		
				
		%% Calculate acceleration - Differentiate velocity to find acceleration

		acceleration = zeros((length(displacement)),1);                                 % create matrix to hold values (dimensions R, C)
		acceleration(1) = 0;                                            				% acceleration at time 0 = 0
		
		for y=[2:(length(displacement))]
			dTheta =(velocity(y)-velocity(y-1))
			dTime = (time(y)-time(y-1))
			omega = dTheta/dTime                                                        % find acceleration from velocity differential mms^-2
			acceleration(y,:) = omega; 													% append array of values
		end		
				
		%% Calculate stall force of sma while mass accelerates freely. 
		
		%force = mass*(gravity + acceleration)                                           % Force mN = kg * mm*s^-2
        stall_force = mass*(acceleration)                                           % Force mN = kg * mm*s^-2
		
        %acceleration = zero_phase_filter(20, acceleration)  
		velocity = zero_phase_filter(20, velocity);                                     % filter the results to smooth the signal	
		force = zero_phase_filter(20, force)	;
        
        %Find indices of +ve accelaeration
        free_acceleration =find(acceleration>0)
		
        % Find stall force during masss accelerating freely
        stall_force_free_acc = stall_force(free_acceleration); 
         
        %....find corresponding power
        motor_power_mW_free_acc =  motor_power_mW(free_acceleration)
        
        plot(motor_power_mW_free_acc,stall_force_free_acc)
        
       
         