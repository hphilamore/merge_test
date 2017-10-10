function [power_10v] = power_calc_10v(risingEdge, encoder_inc, signal_to_filter)

% signal_to_filter = signal_to_filter(risingEdge) 											% trim motor power values to give those at rising edges
% encoder_filtered_signal = [0;signal_to_filter(encoder_inc:encoder_inc:end)]; 


encoder_filtered_signal = signal_to_filter(risingEdge) 											% trim motor power values to give those at rising edges
 


