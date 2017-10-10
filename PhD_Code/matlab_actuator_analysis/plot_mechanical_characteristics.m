%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sma_ipmc_mechanical : CALC ROTATIONS, ANGULAR SPEED, AND TORQUE FOR SMA/IPMC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%function[time_rising_edge, motor_power_mW, number_rotations, angular_velocity, torque] = sma_ipmc_mechanical (time, displacement, motor_power, minDuration, threshold, encoder_inc, efficiency_motor)

	
	
	x=size(mechanical_characteristics_ax1)
	for j = [1:x(2)]
	%for j=[5]
			
			if ~isempty(findstr(filename,'maxon'))|~isempty(findstr(filename,'escap'))	
			hl1 = line(time_rising_edge(:,1),mechanical_characteristics_ax1(:,j),'LineWidth', 1.5, 'Color',[1, 0.3*j, 1-(0.3*j)]);

				else
					hl1 = line(time,mechanical_characteristics_ax1(:,j),'LineWidth', 1.5, 'Color',[1, 0.3*j, 1-(0.3*j)]);
			end
		
		ax1 = gca;

		set(ax1,'XColor','k','YColor','k', 'Fontsize', 14)

		x=xlabel(x_label_1)
		set(x, 'FontSize', 20)
		%set(x,'FontWeight', 'bold')

		y=ylabel(y_label_1) 
		set(y, 'FontSize', 20)
		%set(y,'FontWeight', 'bold')
		
		a_legend = legend(legend_1)
		set (a_legend,'FontSize',18, 'Box', 'Off', 'location', 'northwest');
	
	end
		
	ax2 = axes('Position',get(ax1,'Position'),...
		   'XAxisLocation','top',...
		   'YAxisLocation','right',...
		   'Color','none',...
		   'XColor','k','YColor','k');
       
    %% plot a second axis for dc motors and sma only    
			   
	if ~isempty(findstr(filename,'maxon'))|~isempty(findstr(filename,'escap'))|~isempty(findstr(filename, 'sma'))       
	
                x=size(mechanical_characteristics_ax2)
                for j = [1:x(2)]

                    if ~isempty(findstr(filename,'maxon'))|~isempty(findstr(filename,'escap'))	   % if motor		
                        hl2 = line(time_rising_edge(:,1),mechanical_characteristics_ax2(:,j),'LineWidth', 1.5, 'Color',[0.2*(j-1), 1, 0.4*j]);

                    else            % if sma/ipmc
                                hl2 = line(time,mechanical_characteristics_ax2(:,j),'LineWidth', 1.5, 'Color',[0.2*(j-1), 1, 0.4*j]);
                        end

                end

            
	
        ax2 = gca;

        set(ax2,'XColor','k','YColor','k', 'Fontsize', 14, 'XTickLabel','')

        y=ylabel(y_label_2) 
        set(y, 'FontSize', 20)

        a_legend = legend(legend_2) 
        set (a_legend,'FontSize',18, 'Box', 'Off', 'location', 'northeast');
        
    end    
	
	%%%% GIVE IT A TITLE	
		
	title_plot=title(file{i})
	set (title_plot,'FontSize',12); 
	
	%%%% LABEL GRAPH WITH ENERGY AND MECHANICAL EFFICIENCY
	
	str = {energy_str, efficiency_str} 
	%avg_power_transfer_efficiency_str, std_power_transfer_efficiency_str};
	annotation('textbox', [0.2,0.5,0.1,0.1],'LineStyle', 'None',...														%		annotate with 
	'String', str);
	
	hold on 
	
	%%%Save the plot

	a=gcf
	% set(y,'FontWeight', 'bold')	
	set(a,'PaperOrientation','landscape');
	set(a,'PaperUnits','normalized');
	set(a,'PaperPosition', [0 0 1 1]);
	fname = 'C:\Users\h-philamore\Google Drive\Experiment - Combined power and actuation\circuits\experiment yr 3\actuation_tests_10_2014\actuation_test_mech';
	filename = [file{i}, '.jpeg']
	saveas(a, fullfile(fname, filename));
	filename = [file{i}, '.fig']
	saveas(a, fullfile(fname, filename));
	filename = [file{i}, '.pdf']
	saveas(a, fullfile(fname, filename));
	
	%% CLEAR FIGURE FOR NEXT PLOT
	clf  