
function main

global p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 ...
       a_tw psi_tw delta_s delta_r Wc_aw Wp_aw gs gr ...
       F_s F_r x y theta v w;

% model 
p1 = 0.03;
p2 = 40;
p3 = 60;
p4 = 200;
p5 = 1500;
p6 = 0.5;
p7 = 0.5;
p8 = 2;
p9 = 120;
p10 = 400;
p11 = 0.2;
% plane area
A_s = 0.25;
A_r = 0.05;
% lift and drag coefficients
Cl_s = 1;
Cd_s = 0.1;
Cl_r = 1;
Cd_r = 0.1;

% time 
tspan = [0 1];

% intial conditions
x = 0
y = 0
theta = pi/4
v = 0
w = 0
Z_init = [x y theta v w]

% wind
a_tw = 10
psi_tw = pi * 1.6

% rudder and sail angle
delta_s = -0.2                                         
delta_r = 0                                       

% apparent wind
Wc_aw = appWind_c(a_tw, psi_tw, theta, v)
[Wp_aw, a_aw, psi_aw] = appWind_p(Wc_aw)

L_s = aero_force(A_s, a_aw, Cl_s)
D_s = aero_force(A_s, a_aw, Cd_s)
L_r = hydro_force(A_r, v, Cl_r)
D_r = hydro_force(A_r, v, Cd_r);

F_s = sumAeroVectors(L_s, D_s)  
F_r = sumAeroVectors(L_r, D_r) 
gs = -p4 * a_aw * sin(delta_s - psi_aw)
gr = -p5 * v^2 * sin(delta_r) 
%gr = -sign(psi_aw) * min(abs(pi - abs(psi_aw)), abs(delta_s));    

figure(1)
figure(2)

for j = 1:15

    [t,z] = ode45(@(t,Z) sailboat(t,Z), tspan, Z_init);

    figure(1)
    plot(t,z(:,1),'r',t,z(:,2),'g', ...
       t,z(:,3),'b',t,z(:,4),'m',t,z(:,5),'k')
    hold on 

    % update initial conditions for next iteration: x y theta v w
    x = z(end,1);
    y = z(end,2);
    theta = z(end,3);
    v = z(end,4);
    w = z(end,5);
    Z_init = [x y theta v w]
    
    figure(2) 
    DrawRectangle([Z_init(1), Z_init(2), 1.8, 1.2, Z_init(3), 1.2, ...
                   delta_s, a_tw, psi_tw], 'r-'); 
    plot(Z_init(1), Z_init(2),'b')
    hold on
    
    % update tspan
    tspan = tspan + 1;
    
    % CONTROLLER                    % todo!
    % update sail and rudder angle
    %delta_s = abs(delta_s) + 0.05
    %delta_r = abs(delta_r) + 0.1    
    
    % update wind angle and magnitude    
    a_tw = abs(a_tw) + 1;
    psi_tw = abs(psi_tw);   
    
%     if (j > 9)
%         %psi_tw = -1 * psi_tw
%         delta_s = 0
%         
%     end

    % re-compute parameters
    % apparent wind
    Wc_aw = appWind_c(a_tw, psi_tw, theta, v)
    [Wp_aw, a_aw, psi_aw] = appWind_p(Wc_aw)

    L_s = aero_force(A_s, a_aw, Cl_s)
    D_s = aero_force(A_s, a_aw, Cd_s)
    L_r = hydro_force(A_r, v, Cl_r)
    D_r = hydro_force(A_r, v, Cd_r);

    F_s = sumAeroVectors(L_s, D_s)  
    F_r = sumAeroVectors(L_r, D_r) 
    gs = -p4 * a_aw * sin(delta_s - psi_aw) 
    gr = -p5 * v^2 * sin(delta_r)  
    %gr = -sign(psi_aw) * min(abs(pi - abs(psi_aw)), abs(delta_s));    
   
end

figure(1)
legend('x', 'y', 'theta', 'v', 'w')

function dZdt = sailboat(t,Z)

global p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 ...
       a_tw psi_tw delta_s delta_r Wc_aw Wp_aw gs gr ...
       F_s F_r x y theta v w;

model = 'new'

dZdt = [ ...
        % x
        dxdt(Z(4), Z(3));
        % y
        dydt(Z(4), Z(3));
        % theta
        dthdt(Z(5));
        % v
        dvdt(Z(4), model);
        % w
        dwdt(Z(4), Z(5), model);
        ]; 
    
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
if(m ~= 1 || n ~= 9)
    error('param should be an 1x5 array.');
end
if(param(3) <=0 || param(4) <=0)
    error('width and height must be positive values.');
end
a = param(1);
b = param(2);
w = param(3);
h = param(4);
l = param(6);
theta = param(5);
delta_s = param(7);
a_tw = param(8);
psi_tw = param(9);

X = [-w/2 w/2 w/2 -w/2 -w/2];
Y = [h/2 h/2 -h/2 -h/2 h/2];
P = [X;Y];
ct = cos(theta);
st = sin(theta);
R = [ct -st;st ct];
P = R * P;
h = plot(P(1,:)+a,P(2,:)+b,style);

S = [a, a + l * cos(theta + delta_s - pi); ...
     b, b + l * sin(theta + delta_s - pi)];
f = plot(S(1,:),S(2,:),'b');

% W = [a + a_tw * cos(psi_tw), -a_tw * cos(psi_tw); ...
%      b + a_tw * sin(psi_tw), -a_tw * sin(psi_tw)];
W = [a - a_tw * cos(psi_tw), a_tw * cos(psi_tw); ...
     b - a_tw * sin(psi_tw), a_tw * sin(psi_tw)];
g = quiver(W(1,1),W(2,1),W(1,2),W(2,2),'g');
axis equal;

function out = appWind_c(a_tw, psi_tw, theta, v)
%--------------------------------------------------------------------------
% Uses polar components of true wind to compute cartesian components of 
% apparent wind:
% - inputs:
%          a_tw : magnitude of true wind velocity
%          psi_tw : true wind angle relative to north-east-up frame
%          theta : heading angle relative to north-east-up frame
%          v : PMW velocity in direction of heading 
% - output:
%          out....................... 2x1 array
%          out : cartesian components of apparent wind relative to PMW
%          frame
%--------------------------------------------------------------------------
out = [(a_tw * cos(psi_tw - theta) - v); ...
       (a_tw * sin(psi_tw - theta))]
   
function [out1, out2, out3] = appWind_p(Wc_aw)
%--------------------------------------------------------------------------
% Uses cartesian components of apparent wind to compute polar components: 
% - inputs:
%          Wc_aw....................... 2x1 array
%          Wc_aw : cartesian components of apparent wind relative to PMW
%          frame
% - output:
%          out1....................... 2x1 array
%          out1 : polar components of apparent wind [mag; angle] relative to PMW
%          frame
%          out2 : magnitude of apparent wind velocity 
%          out3 : apparent wind angle relative to PMW frame
%--------------------------------------------------------------------------
out1 = [hypot(Wc_aw(2,:), Wc_aw(1,:)); ...
       atan2(Wc_aw(2,:), Wc_aw(1,:))];

out2 = out1(1,:);

out3 = out1(2,:);

function out = aero_force(A_plane, v_fluid, C)
%--------------------------------------------------------------------------
% Lift or drag force, square of velocity neglected due to roll of body
% - inputs:
%          A_plane : plane area of sail or wing
%          v_fluid : fluid velocity
%          C : lift or drag coefficent
% - output:
%          out : force (N)
%--------------------------------------------------------------------------
rho_air = 1.225;
out = 0.5 * rho_air * A_plane * v_fluid^2 * C 

function out = hydro_force(A_plane, v_fluid, C)
%--------------------------------------------------------------------------
% Lift or drag force
% - inputs:
%          A_plane : plane area of sail or wing
%          v_fluid : fluid velocity
%          C : lift or drag coefficent
% - output:
%          out : force (N)
%--------------------------------------------------------------------------
rho_air = 1.225;
out = 0.5 * rho_air * A_plane * v_fluid^2 * C

function out = sumAeroVectors(lift,drag)
%--------------------------------------------------------------------------
% Find the resultant of perpendicular lift or drag forces as polar
% components.
% - inputs:
%          lift : plane area of sail or wing
%          drag : fluid velocity
% - output:
%          out....................... 2x1 array
%          out : Polar components of resultant force [mag; angle]
%--------------------------------------------------------------------------
out = [-hypot(lift, drag); ...
       atan2(lift, drag)]; 

% function out = oldAeroVectors(part)
% %--------------------------------------------------------------------------
% % Find the resultant of perpendicular lift or drag forces as polar
% % components.
% % - inputs:
% %          lift : plane area of sail or wing
% %          drag : fluid velocity
% % - output:
% %          out....................... 2x1 array
% %          out : Polar components of resultant force [mag; angle]
% %--------------------------------------------------------------------------
% global p4 p5 a_aw delta_s delta_r psi_aw v
% 
% if part == 'new'
%     %out = -p4 * a_aw * sin(delta_s - psi_aw)
%     out = -p5 * v^2 * sin(delta_r); 
%     
% elseif part == 'old'
%     out = -p5 * v^2 * sin(delta_r) 
% end

function out = dxdt(v,theta)
%--------------------------------------------------------------------------
% The horizontal velocity of the PMW. 
% sum of:
% - x component of velocity (in direction of heading) in  north-east-up frame
% - horizontal drift due to the true wind velocity
% - input:
%          v : velocity
%          theta : heading angle
% - output:
%          out : horizontal velocity
%--------------------------------------------------------------------------
global p1 a_tw psi_tw;   
out =  v * cos(theta) + p1 * a_tw * cos(psi_tw); ...
    
function out = dydt(v, theta)
%--------------------------------------------------------------------------
% The vertical velocity of the PMW. 
% sum of:
% - y component of velocity (in direction of heading) in  north-east-up frame
% - vertical drift due to the true wind velocity
% - input:
%          v : velocity
%          theta : heading angle
% - output:
%          out : horizontal velocity
%--------------------------------------------------------------------------
global p1 a_tw psi_tw;   
out =  v * sin(theta) + p1 * a_tw * sin(psi_tw); ...
    
function out = dthdt(w)
%--------------------------------------------------------------------------
% The angular velocity of the PMW. 
%          out : angular velocity
%--------------------------------------------------------------------------
out = w; ...
    
function out = dvdt(v, version)
%--------------------------------------------------------------------------
% The acceleration of the PMW in the direction of the heading (theta). 
% Component of wind force on sail acting parallel to heading direction  
% minus the product of:
% - component of water force on rudder acting parallel to heading direction
% - rudder break coefficient
% - input:
%          v : velocity
%          version : old model or new model
% - output:
%          out : acceleration
%--------------------------------------------------------------------------
global p2 p9 p11 gs gr F_s F_r delta_s delta_r;

if version == 'old'
    out = (gs * sin(delta_s) - gr * p11 * sin(delta_r) - p2 * v^2) / p9; ...

elseif version == 'new'
    out = ( -F_s(1,:) * cos(F_s(2,:)) + F_r(1,:) * cos(F_r(2,:))) / p9; ...
end

function out = dwdt(v,w,version)
%--------------------------------------------------------------------------
% The acceleration of the PMW in the direction of the heading (theta). 
% Component of wind force on sail acting parallel to heading direction  
% minus the product of:
% - component of water force on rudder acting parallel to heading direction
% - rudder break coefficient
% - input:
%          v : velocity
%          v : angular velocity
%          version : old model or new model
% - output:
%          out : acceleration
%--------------------------------------------------------------------------
global p3 p6 p7 p8 p10 gs gr F_s F_r delta_s delta_r;

if version == 'old'
    out =  (gs * (p6 - p7 * cos(delta_s)) - gr * p8 * cos(delta_r) - p3 ...
                * v * w) / p10; ...
elseif version == 'new'
    out = ( -F_s(1,:) * sin(F_s(2,:)) * (p6 - p7 * cos(delta_s))) ...
        - (-F_r(1,:) * sin(F_r(2,:)) * p8 * cos(delta_r)) / p10; ...
end
    
