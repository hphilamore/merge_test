
	
	
	x=size(electrical_characteristics_ax1)
	for j = [1:x(2)]
	%for j=[5]
			
		hl1 = line(time,electrical_characteristics_ax1(:,j),'LineWidth', 1.5, 'Color',[(0.3*j),1-(0.1*j),1]);
		%ylim([0,6])
		
		ax1 = gca;

		set(ax1,'XColor','k','YColor','k', 'Fontsize', 14)
		
		if ~isempty(findstr(filename,'maxon'))|~isempty(findstr(filename,'escap')) | ~isempty(findstr(filename,'sma'))                  
			ylim([0,6])
			else ylim([-6,6])
				
		end

		x=xlabel(x_label_1)
		set(x, 'FontSize', 20)
		%set(x,'FontWeight', 'bold')

		y=ylabel(y_label_1) 
		set(y, 'FontSize', 20)
		%set(y,'FontWeight', 'bold')
		
		a_legend = legend(legend_1)
		set (a_legend,'FontSize',18, 'Box', 'Off', 'location', 'north');
	
	end
		
		ax2 = axes('Position',get(ax1,'Position'),...
			   'XAxisLocation','top',...
			   'YAxisLocation','right',...
			   'Color','none',...
			   'XColor','k','YColor','k');
			   
	
	
	x=size(electrical_characteristics_ax2)
	for j = [1:x(2)]
			
		hl2 = line(time,electrical_characteristics_ax2(:,j),'Parent',ax2, 'LineWidth', 1.5, 'Color',[0.5,1,(0.4*j)]);
		
        if ~isempty(findstr(filename,'maxon'))|~isempty(findstr(filename,'escap')) | ~isempty(findstr(filename,'sma'))
			ylim([0,p_max]) 
			else ylim([-p_max,p_max])
				
		end
        
        %ylim([0,p_max]) 
            																													%limit y values to max power value
	end

	
		

	ax2 = gca;

	set(ax2,'XColor','k','YColor','k', 'Fontsize', 14, 'XTickLabel','')

	y=ylabel(y_label_2) 
	set(y, 'FontSize', 20)
	% set(y,'FontWeight', 'bold')
	
	a_legend = legend(legend_2) 
	set (a_legend,'FontSize',18, 'Box', 'Off', 'location', 'northeast');
	
	title_plot=title(file{i})
	set (title_plot,'FontSize',12); 
	
% 	str = {avg_resistance_motor_str, std_resistance_motor_str, V_cap_str};
% 	annotation('textbox', [0.2,0.5,0.1,0.1],'LineStyle', 'None',...														%		annotate with 
% 	'String', str);

    str = {avg_resistance_motor_str, std_resistance_motor_str, V_cap_str};
	annotation('textbox', [0.7,0.7,0.1,0.1],'LineStyle', 'None',...														%		annotate with 
	'String', str);
	
	
	
	hold on 
	
	%%%Save the plot

	a=gcf
	% set(y,'FontWeight', 'bold')	
	set(a,'PaperOrientation','landscape');
	set(a,'PaperUnits','normalized');
	set(a,'PaperPosition', [0 0 1 1]);
	fname = 'C:\Users\h-philamore\Google Drive\Experiment - Combined power and actuation\circuits\experiment yr 3\actuation_tests_10_2014\actuation_test_elec';
	filename = [file{i}, '.jpeg']
	saveas(a, fullfile(fname, filename));
	filename = [file{i}, '.fig']
	saveas(a, fullfile(fname, filename));
	filename = [file{i}, '.pdf']
	saveas(a, fullfile(fname, filename));
	
	%% CLEAR FIGURE FOR NEXT PLOT
	clf  