
function main

global p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 ...
       a_tw psi_tw delta_s delta_r Wc_aw Wp_aw gs gr % x y theta v w

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
tspan = [0 1];

% intial conditions
x = 1
y = 1
theta = pi/4 
v = 50
w = 5

Z_init = [x y theta v w]

% input parameters
a_tw = 10
psi_tw = 100

delta_s = 1                                         %% todo 
delta_r = 1                                         %% todo

% computed parameters
Wc_aw = [(a_tw * cos(psi_tw - theta) - v) ...
         (a_tw * cos(psi_tw - theta) - v)]

Wp_aw = [abs(Wc_aw) ...
         atan(Wc_aw)]

gs = 1                                              %% todo
gr = 1                                              %% todo

% examples
% A = 1;
% B = 4;
%[t,y] = ode45(@(t,y) odefcn(t,y,A,B), tspan,[0 0.01]);   % to run internal function OR external function with additional arguments
%[t,y] = ode45(@(t,y) elastic(t,y), [0 12],[0 1 1]);      % to run internal function 
%[t,y] = ode45('rigid',[0 12],[0 1 1]);                   % to run external function without additional arguments

% two different ways to express same solution
% method 1: solution as rows
% sol = ode45(@sailboat, tspan, [x y theta v w]);
% plot(sol.x,sol.y);
% a = sol.y
% b = a(1,:)

% method 2: solution as columns
% [t,z] = ode45(@(t,Z) sailboat(t,Z), tspan, [x y theta v w]);
[t,z] = ode45(@(t,Z) sailboat(t,Z), tspan, Z_init);
%plot(t,z);
plot(t,z(:,1),'r-o',t,z(:,2),'g-d', ...
    t,z(:,3),'b-s',t,z(:,4),'m-^',t,z(:,5),'k-*')

% a = z
% b = z(:,1)
% b(end)
for i=1:5
    Z_init(i) = z(end,i);
end
    

x = z(end,1)
% x = x(end)
% y = z(:,2)
% x = x(end)
% x = z(:,3)
% x = x(end)
% x = z(:,4)
% x = x(end)
% x = z(:,5)
% x = x(end)

% y = 
% theta = 
% v = 
% w = 





function dZdt = sailboat(t,Z)

global p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 ...
       a_tw psi_tw delta_s delta_r Wc_aw Wp_aw gs gr % x y theta v w

dZdt = [ ...
        Z(4) * cos(Z(3)) + p1 * a_tw * cos(psi_tw); ...
        Z(4) * sin(Z(3)) + p1 * a_tw * sin(psi_tw); ...
        Z(5); ...
        (gs * sin(delta_s) - gr * p11 * sin(delta_r) - p2 * Z(4)^2) / p9; ...
        (gs * (p6 - p7 * cos(delta_s)) - gr * p8 * cos(delta_r) - p3 ...
            * Z(5) * Z(4)) / p10; ...
        ]

% function dy = elastic(t,y)
% dy = zeros(3,1);    % a column vector
% dy(1) = y(1) * y(3);
% dy(2) = -y(3) * y(3);
% dy(3) = -0.51 * y(1) * y(2);







