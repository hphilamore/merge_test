function main

global L

close all;
clear all;
clc;

x_init = 0; %[m]
y_init = 0; %[m]
T_init = pi/4; % rads

% x_target = 5; %[m]
% y_target = 5; %[m]

w_r = 1.5; %[rads/s]
w_l = 2; %[rads/s]
r = 0.05; % wheel radius [m]
L = 0.1; % distance btwn wheels [m]

% x_vel_R = r * (w_r + w_l) / 2; %[m/s]
% y_vel_R = 0; %[m/s]
% T_vel_R = r * (w_r - w_l) / L; %[m/s]

vel_R = [r * (w_r + w_l) / 2; 
         0; 
         r * (w_r - w_l) / L]; 

% target_reached = 0;
duration = 10.0;
timestep = 2; %[s]
samples = (duration / timestep) + 1;
sample_no = 1;
timestamps(sample_no) = 0;
tol = 0.1; %[m]

x_robot(sample_no) = x_init;
y_robot(sample_no) = y_init;
T_robot(sample_no) = T_init;

% R = [cos(T_robot(sample_no)) -sin(T_robot(sample_no)) 0;
%      sin(T_robot(sample_no)) cos(T_robot(sample_no))  0;
%         0           0           1]

while sample_no < samples
    %increase timestep  
    
    R = [cos(T_robot(sample_no)) -sin(T_robot(sample_no)) 0;
         sin(T_robot(sample_no)) cos(T_robot(sample_no))  0;
         0           0           1]
    
    vel_I = R * vel_R    
    
    sample_no =  sample_no + 1;

    %calcualte new postition
    x_robot(sample_no) = x_robot(sample_no - 1) + vel_I(1) * timestep;
    y_robot(sample_no) = y_robot(sample_no - 1) + vel_I(2) * timestep;
    T_robot(sample_no) = T_robot(sample_no - 1) + vel_I(3) * timestep;
    %store timestep
    timestamps(sample_no) = timestamps(sample_no - 1) + timestep; 
    
%     %check if target is reached
%     if ((abs(x_robot(sample_no) - x_target) < tol) || (abs(y_robot(sample_no) - y_target) < tol))
%         target_reached = 1;
%     end

    %insert animation here
    %...
end

figure
plot(x_robot, y_robot);
hold on

for i= 1:samples
    DrawRectangle([x_robot(i),y_robot(i),L,L,T_robot(i)],'r-');
end

x_robot
y_robot
T_robot
%plot(x_robot, timestamps);
% figure 
% %plot(y_robot, timestamps);

function h = DrawRectangle(param,style)
%--------------------------------------------------------------------------
% H = DRAWRECTANGLE(PARAM,STYLE)
% This function draws a rectangle with the given parameters:
% - inputs:
%          param................... 1x5 array
%          - param = [a, b, w, h, theta]
%          - (a,b): the center of the rectangle
%          - (w,h): width and height of the rectangle > 0
%          - theta: the rotation angle of the rectangle
%          style................... string
%          - plot style string
% - output:
%          h....................... plot handler
%
%   Usage Examples,
%
%   DrawRectangle([0 0 1 1 0]); 
%   DrawRectangle([-1,2,3,5,3.1415/6],'r-');
%   h = DrawRectangle([0,1,2,4,3.1415/3],'--');
%--------------------------------------------------------------------------
if (nargin <1),
    error('Please see help for INPUT DATA.');
elseif (nargin==1)
    style='b-';
end;
[m,n] = size(param);
if(m ~= 1 || n ~= 5)
    error('param should be an 1x5 array.');
end
if(param(3) <=0 || param(4) <=0)
    error('width and height must be positive values.');
end
a = param(1);
b = param(2);
w = param(3);
h = param(4);
theta = param(5);
X = [-w/2 w/2 w/2 -w/2 -w/2];
Y = [h/2 h/2 -h/2 -h/2 h/2];
P = [X;Y];
ct = cos(theta);
st = sin(theta);
R = [ct -st;st ct];
P = R * P;
h=plot(P(1,:)+a,P(2,:)+b,style);
axis equal;

