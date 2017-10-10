% Swiming stroke time of maxima
maxima_4_1 = [45.36, 46.9, 48.54, 50, 51.54, 53.1, 54.76, 56.44, 58.2, 59.84, 61.64, 63.52]
maxima_5_5 = [49.38, 50.62, 51.76, 52.9, 54.1, 55.3, 56.44, 57.76, 59.04, 60.22]

% Duration each stroke
duration_4_1 = diff(maxima_4_1)
duration_5_5 = diff(maxima_5_5)

frequency_4_1 = duration_4_1.^-1
frequency_5_5 = duration_5_5.^-1

mean(frequency_4_1)
std(frequency_4_1)
mean(frequency_5_5)
std(frequency_5_5)

% mean(duration_4_1)
% std(duration_4_1)
% mean(duration_5_5)
% std(duration_5_5)

cycles_4_1 = length(maxima_4_1)
cycles_5_5 = length(maxima_5_5)

wetted_area_mm = 58952.16 
wetted_area_m = wetted_area_mm * 10^-6

frontal_area_mm = 2831.45
frontal_area_m = frontal_area_mm * 10^-6

work_4_1 =  0.5 * 1000 * 0.01^3 * wetted_area_m * 20

work_5_5 =  0.5 * 1000 * 0.0166^3 * wetted_area_m * 12 

E_4_1 = 0.81
E_5_5 = 0.7

eff_4_1 = work_4_1 / E_4_1
eff_5_5 = work_5_5 / E_5_5

