function main

global L

close all;
clear all;
clc;

direction = 'clockwise'

tStraight = 1.9
tTurn = 0.45

w_orig = 8.8

Rn = 0.03 % nominal wheel radius

Cb = 0.850321794
   % wheel base correction factor
Cdl = 0.979989867
  % right wheel diameter correction factor
Cdr = 1.020010133
  % left wheel diameter correction factor

Rr = Rn * Cdr % wheel radius [m] 0.031
Rl = Rn * Cdl % wheel radius [m] 0.029

% w_rStraight = 8.59
% w_lStraight = 9.04 
w_rTurn = 7.22
w_lTurn = 7.74

% w_rStraight = 8.59
% w_lStraight =  9.04 
% w_rTurn = w_orig * Rn / Rr
% w_lTurn =  w_orig * Rn / Rl

w_rStraight = w_orig
w_lStraight = w_orig
% w_rTurn = w_orig
% w_lTurn = w_orig





x_init = 0; %[m]
y_init = 0; %[m]
T_init = 0; % rads

Ln = 0.15; % distance btwn wheels [m]
L = Ln * Cb

sample_no = 1;
timestamps(sample_no) = 0;
x_robot(sample_no) = x_init;
y_robot(sample_no) = y_init;
T_robot(sample_no) = T_init;

% CLOCKWISE

timestep = 0.01

for i = 1:4

    for i = 0 : timestep : tStraight
        w_r = w_rStraight; %[rads/s];
        w_l = w_lStraight; %[rads/s];
        v_l = Rl * w_l;
        v_r = Rr * w_r;
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

    for i = 0 : timestep : tTurn
        w_r = w_rTurn; %[rads/s]
        w_l = -w_lTurn; %[rads/s]
        v_l = Rl * w_l ;
        v_r = Rr * w_r;
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
end


figure
plot(x_robot, y_robot, 'r');
hold on



sample_no = 1;
timestamps(sample_no) = 0;
x_robot(sample_no) = x_init;
y_robot(sample_no) = y_init;
T_robot(sample_no) = T_init;

% CLOCKWISE

timestep = 0.01

for i = 1:4

    for i = 0 : timestep : tStraight
        w_r = w_rStraight; %[rads/s];
        w_l = w_lStraight; %[rads/s];
        v_l = Rl * w_l;
        v_r = Rr * w_r;
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

    for i = 0 : timestep : tTurn
        w_r = -w_rTurn; %[rads/s]
        w_l = w_lTurn; %[rads/s]
        v_l = Rl * w_l ;
        v_r = Rr * w_r;
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
end



plot(x_robot, y_robot);
hold on



sample_no = 1;
timestamps(sample_no) = 0;
x_robot(sample_no) = x_init;
y_robot(sample_no) = y_init;
T_robot(sample_no) = T_init;

% COUNTER CLOCKWISE 

timestep = 0.01

for i = 1:4

    for i = 0 : timestep : tStraight
        w_r = w_rStraight; %[rads/s];
        w_l = w_lStraight; %[rads/s];
        v_l = 0.26;
        v_r = 0.26;
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

    for i = 0 : timestep : tTurn
        w_r = -w_rTurn; %[rads/s]
        w_l = w_lTurn; %[rads/s]
        v_l = 0.218% Rl * w_l ;
        v_r = -0.218%Rr * w_r;
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
end

% SQAURE CLOCKWISE
%figure
plot(x_robot, y_robot, 'g');
hold on
% 
sample_no = 1;
timestamps(sample_no) = 0;
x_robot(sample_no) = x_init;
y_robot(sample_no) = y_init;
T_robot(sample_no) = T_init;

w_rStraight = 8.59
w_lStraight = 9.04 
w_rTurn = 7.22
w_lTurn = 7.74

w_rStraight = 8.59
w_lStraight =  9.04 
w_rTurn = w_orig * Rn / Rr
w_lTurn =  w_orig * Rn / Rl

w_rStraight = w_orig
w_lStraight = w_orig
w_rTurn = w_orig
w_lTurn = w_orig



timestep = 0.01

for i = 1:4

    for i = 0 : timestep : tStraight
        w_r = w_rStraight; %[rads/s];
        w_l = w_lStraight; %[rads/s];
        v_l = 0.26;
        v_r = 0.26;
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

    for i = 0 : timestep : tTurn
        w_r = -w_rTurn; %[rads/s]
        w_l = w_lTurn; %[rads/s]
        v_l = -0.218% Rl * w_l ;
        v_r = 0.218%Rr * w_r;
        
       
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
end




%figure
plot(x_robot, y_robot, 'g');
hold on
% 
% % for i= 1:10:length(x_robot)
% %     DrawRectangle([x_robot(i),y_robot(i),L,L,T_robot(i)],'r-');
% % end

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

