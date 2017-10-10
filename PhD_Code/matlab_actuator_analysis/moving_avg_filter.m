function [filtered_signal] = moving_avg_filter(window, signal_to_filter)

% % Low pass filter on output from shunt resister
	%window = 250 																		% no of points (20ms each at 50Hz) to average
	numerator = ones(1, window)/window;     											% matrix of length window, each value = 1/window
	denominator = 1                         											% denominator is scaler 1, so that coefficient = numerator/denominator = numerator
	filtered_signal = filter(numerator, denominator, signal_to_filter);					% filter values
	%avg_current_shunt_amp = filter(numerator, denominator, current_shunt_amp);		