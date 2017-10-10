function main

global M 
global L
global rn

close all;
clear all;
clc;

M = 50 % length of one side of square path [cm]
Ln = 15 % nomical distance btwn wheels [cm]
rn = 3 % nomical wheels radius [cm]

% x and y error of final position in CW and CCW directions
Xcw = [-2 ,6.5, 7.6, 6.8, 1]     
Ycw = [-3, 6.5, 6.5, 6.5, 6.5]
Xccw = [16, 19, 19, 16, 15]
Yccw = [-7.5, -9.5, -7.2, -6, -7.8]

Xcw = mean(Xcw)
Ycw = mean(Ycw)
Xccw = mean(Xccw)
Yccw = mean(Yccw)

% alpha and beta error angles
Ax = (Xcw + Xccw)/ (-4 * M)
Ay = (Ycw - Yccw)/ (-4 * M)
Bx = (Xcw - Xccw)/ (-4 * M)
By = (Ycw + Yccw)/ (-4 * M)

Aave = mean([Ax, Ay])
Bave = mean([Bx, By])

R = (M/2)/sin(Bave/2)       % radius of curvature of actual robot path [cm]

etaD = (R+(Ln/2))/(R-(Ln/2))  % wheel diameter error ratio

etaL = 0.5 * pi / (0.5 * pi - Aave) % wheel base error ratio

CL = etaL                   % wheel base correction factors
CDl =  2 / (etaD + 1)       % left wheel correction factor
CDr =  2 / ((1/etaD) + 1)   % right wheel correction factor

w_orig = 8.8                % measured speed at PWM = 180


tStraight = M / (rn * w_orig) %1.9 % time to travel one side of square path 
tTurn = ((pi/2) * Ln) / (2 * rn * w_orig) %0.45 time to turn 90 degrees

% corrected geometric values
rr = rn * CDr % wheel radius [m] 0.031
rl = rn * CDl % wheel radius [m] 0.029
L = Ln * CL

w_rStraight = w_orig
w_lStraight = w_orig 
w_rTurn = w_orig
w_lTurn = w_orig
% 
% w_rStraight = w_orig * CDl
% w_lStraight = w_orig * CDr
% w_rTurn = w_orig * CDl * CL
% w_lTurn = w_orig * CDr * CL

w_rStraight = w_orig / CDr
w_lStraight = w_orig / CDl
w_rTurn = CL * w_orig %/ CDr 
w_lTurn = CL * w_orig %/ CDl

% tStraightr = tStraight / CDr
% tStraightl = tStraight / CDl
% tTurnr = CL * tTurn / CDr 
% tTurnl = CL * tTurn / CDl

tStraight = M / (rn * w_orig) %1.9 % time to travel one side of square path 
tTurn = ((pi/2) * Ln) / (2 * rn * w_orig) %0.45 time to turn 90 degrees

% Cb = 0.850321794
%    % wheel base correction factor
% Cdl = 0.979989867
%   % right wheel diameter correction factor
% Cdr = 1.020010133
 
% w_rStraight = 8.59
% w_lStraight = 9.04 
% w_rTurn = 7.22
% w_lTurn = 7.74
% 
% w_rStraight = 8.59
% w_lStraight =  9.04 
% w_rTurn = w_orig * Rn / Rr
% w_lTurn =  w_orig * Rn / Rl

x_init = 0; %[m]
y_init = 0; %[m]
T_init = 0; % rads

sample_no = 1;
timestamps(sample_no) = 0;
x_robot(sample_no) = x_init;
y_robot(sample_no) = y_init;
T_robot(sample_no) = T_init;

timestep = 0.01

for i = 1:4

for i = 0 : timestep : tStraight
%for i = 0 : timestep : tStraightr
    
        w_r = w_rStraight; %[rads/s];
        w_l = w_lStraight; %[rads/s];
        v_l = rl * w_l;
        v_r = rr * w_r;
%         v_l = floor(v_l*100)/100 
%         v_r = floor(v_r*100)/100 

         vel_R = [
                    (v_r + v_l) / 2; 
                     0; 
                    (v_r - v_l) / L
                 ] ;

        R = [cos(T_robot(sample_no)) -sin(T_robot(sample_no)) 0;
             sin(T_robot(sample_no)) cos(T_robot(sample_no))  0;
             0           0           1];

        vel_I = R * vel_R    ;

        sample_no =  sample_no + 1;

        %calcualte new postition
        x_robot(sample_no) = x_robot(sample_no - 1) + vel_I(1) * timestep;
        y_robot(sample_no) = y_robot(sample_no - 1) + vel_I(2) * timestep;
        T_robot(sample_no) = T_robot(sample_no - 1) + vel_I(3) * timestep;
        %store timestep
        timestamps(sample_no) = timestamps(sample_no - 1) + timestep; 
end
    
% for i = 0 : timestep : (tStraightl - tStraightr)
%     
%         w_r = 0; %[rads/s];
%         w_l = w_lStraight; %[rads/s];
%         v_l = rl * w_l;
%         v_r = rr * w_r;
% %         v_l = floor(v_l*100)/100 
% %         v_r = floor(v_r*100)/100 
% 
%          vel_R = [
%                     (v_r + v_l) / 2; 
%                      0; 
%                     (v_r - v_l) / L
%                  ] ;
% 
%         R = [cos(T_robot(sample_no)) -sin(T_robot(sample_no)) 0;
%              sin(T_robot(sample_no)) cos(T_robot(sample_no))  0;
%              0           0           1];
% 
%         vel_I = R * vel_R    ;
% 
%         sample_no =  sample_no + 1;
% 
%         %calcualte new postition
%         x_robot(sample_no) = x_robot(sample_no - 1) + vel_I(1) * timestep;
%         y_robot(sample_no) = y_robot(sample_no - 1) + vel_I(2) * timestep;
%         T_robot(sample_no) = T_robot(sample_no - 1) + vel_I(3) * timestep;
%         %store timestep
%         timestamps(sample_no) = timestamps(sample_no - 1) + timestep; 
%     end

for i = 0 : timestep : tTurn
%for i = 0 : timestep : tTurnr
        w_r = -w_rTurn; %[rads/s]
        w_l = w_lTurn; %[rads/s]
        v_l = rl * w_l ;
        v_r = rr * w_r;
%         v_l = floor(v_l*100)/100 
%         v_r = ceil(v_r*100)/100 

         vel_R = [
                    (v_r + v_l) / 2; 
                     0; 
                    (v_r - v_l) / L
                 ] ;

        R = [cos(T_robot(sample_no)) -sin(T_robot(sample_no)) 0;
             sin(T_robot(sample_no)) cos(T_robot(sample_no))  0;
             0           0           1];

        vel_I = R * vel_R ;   

        sample_no =  sample_no + 1;

        %calcualte new postition
        x_robot(sample_no) = x_robot(sample_no - 1) + vel_I(1) * timestep;
        y_robot(sample_no) = y_robot(sample_no - 1) + vel_I(2) * timestep;
        T_robot(sample_no) = T_robot(sample_no - 1) + vel_I(3) * timestep;
        %store timestep
        timestamps(sample_no) = timestamps(sample_no - 1) + timestep;
 end
    
%  for i = 0 : timestep : tTurnl - tTurnr
%         w_r = 0; %[rads/s]
%         w_l = -w_lTurn; %[rads/s]
%         v_l = rl * w_l ;
%         v_r = rr * w_r;
% %         v_l = floor(v_l*100)/100 
% %         v_r = ceil(v_r*100)/100 
% 
%          vel_R = [
%                     (v_r + v_l) / 2; 
%                      0; 
%                     (v_r - v_l) / L
%                  ] ;
% 
%         R = [cos(T_robot(sample_no)) -sin(T_robot(sample_no)) 0;
%              sin(T_robot(sample_no)) cos(T_robot(sample_no))  0;
%              0           0           1];
% 
%         vel_I = R * vel_R ;   
% 
%         sample_no =  sample_no + 1;
% 
%         %calcualte new postition
%         x_robot(sample_no) = x_robot(sample_no - 1) + vel_I(1) * timestep;
%         y_robot(sample_no) = y_robot(sample_no - 1) + vel_I(2) * timestep;
%         T_robot(sample_no) = T_robot(sample_no - 1) + vel_I(3) * timestep;
%         %store timestep
%         timestamps(sample_no) = timestamps(sample_no - 1) + timestep;
%     end
disp('X')    
x_robot(sample_no)
disp('Y')  
y_robot(sample_no)
T_robot(sample_no);    
    
end


figure
plot(x_robot, y_robot);
hold on



% for i= 1:10:length(x_robot)
%     DrawRectangle([x_robot(i),y_robot(i),L,L,T_robot(i)],'r-');
% end
% 
% x_robot
% y_robot
% T_robot
% %plot(x_robot, timestamps);
% % figure 
% % %plot(y_robot, timestamps);
% 
% function h = DrawRectangle(param,style)
% %--------------------------------------------------------------------------
% % H = DRAWRECTANGLE(PARAM,STYLE)
% % This function draws a rectangle with the given parameters:
% % - inputs:
% %          param................... 1x5 array
% %          - param = [a, b, w, h, theta]
% %          - (a,b): the center of the rectangle
% %          - (w,h): width and height of the rectangle > 0
% %          - theta: the rotation angle of the rectangle
% %          style................... string
% %          - plot style string
% % - output:
% %          h....................... plot handler
% %
% %   Usage Examples,
% %
% %   DrawRectangle([0 0 1 1 0]); 
% %   DrawRectangle([-1,2,3,5,3.1415/6],'r-');
% %   h = DrawRectangle([0,1,2,4,3.1415/3],'--');
% %--------------------------------------------------------------------------
% if (nargin <1),
%     error('Please see help for INPUT DATA.');
% elseif (nargin==1)
%     style='b-';
% end;
% [m,n] = size(param);
% if(m ~= 1 || n ~= 5)
%     error('param should be an 1x5 array.');
% end
% if(param(3) <=0 || param(4) <=0)
%     error('width and height must be positive values.');
% end
% a = param(1);
% b = param(2);
% w = param(3);
% h = param(4);
% theta = param(5);
% X = [-w/2 w/2 w/2 -w/2 -w/2];
% Y = [h/2 h/2 -h/2 -h/2 h/2];
% P = [X;Y];
% ct = cos(theta);
% st = sin(theta);
% R = [ct -st;st ct];
% P = R * P;
% h=plot(P(1,:)+a,P(2,:)+b,style);
% axis equal;

