
function main

% model 
p1 = 0.03
p2 = 40
p3 = 6000
p4 = 200
p5 = 1500
p6 = 0.5
p7 = 0.5
p8 = 2
p9 = 300
p10 = 400
p11 = 0.2

% time 
tspan = [0 5];

% intial conditions
x = 1
y = 1
theta = pi/4 
v = 10
w = 1

% input parameters
a_tw = 10
psi_tw = 100
delta_s = 
delta_r = 

% computed parameters
Wc_aw = [(a_tw * cos(psi_tw - theta) - v) ...
         (a_tw * cos(psi_tw - theta) - v)]

Wp_aw = [abs(Wc_aw) ...
         arctan(Wc_aw)]

gs = 
gr = 

% examples
% A = 1;
% B = 4;
%[t,y] = ode45(@(t,y) odefcn(t,y,A,B), tspan,[0 0.01]);   % to run internal function OR external function with additional arguments
%[t,y] = ode45(@(t,y) elastic(t,y), [0 12],[0 1 1]);      % to run internal function 
%[t,y] = ode45('rigid',[0 12],[0 1 1]);                   % to run external function without additional arguments

% sailing model
[t,y] = ode45(@(t,y) sailboat(t,y), tspan, [x y theta v w]);

plot(t,y(:,1),'-o',t,y(:,2),'-.')

function dydt = sailboat(t,y)
dy = zeros(3,1);    % a column vector
dy(1) = v * cos(theta) + p1 * a_tw * cos(psi_tw);
dy(2) = v * sin(theta) + p1 * a_tw * sin(psi_tw);
dy(3) = w;
dy(4) = (gs * sin(delta_s) - gr * p11 * sin(delta_r) - p2 * v^2) / p9;
dy(5) = (gs * (p6 - p7 * cos(delta_s)) - gr * p8 * cos(delta_r) - p3 ...
    * w * v) / p10;

% function dy = elastic(t,y)
% dy = zeros(3,1);    % a column vector
% dy(1) = y(1) * y(3);
% dy(2) = -y(3) * y(3);
% dy(3) = -0.51 * y(1) * y(2);






