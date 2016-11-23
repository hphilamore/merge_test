
function main

global p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 ...
       a_tw psi_tw delta_s delta_r Wc_aw Wp_aw gs gr % x y theta v w

% model 
p1 = 0.03
p2 = 40
p3 = 60
p4 = 200
p5 = 1500
p6 = 0.5
p7 = 0.5
p8 = 2
p9 = 120
p10 = 400
p11 = 0.2

% time 
tspan = [0 1];

% intial conditions
x = 0
y = 0
theta = pi/4 
v = 0
w = 0

Z_init = [x y theta v w]

% input parameters
% wind
a_tw = 0
psi_tw = pi * 3/4

% rudder and sail angle
delta_s = pi/4                                         
delta_r = -pi/4                                        

% computed parameters
%actual wind
Wc_aw = [(a_tw * cos(psi_tw - theta) - v); ...
         (a_tw * sin(psi_tw - theta))]

Wp_aw = [hypot(Wc_aw(2,:), Wc_aw(1,:)); ...
         atan2(Wc_aw(2,:), Wc_aw(1,:))]  
     
a_aw = Wp_aw(1,:);
psi_aw = Wp_aw(2,:);

% force on sail and rudder     
gs = -p4 * a_aw * sin(delta_s - psi_aw)     
gr = -sign(psi_aw) * min(abs(pi - abs(psi_aw)), abs(delta_s)) 

for j = 1:15

    [t,z] = ode45(@(t,Z) sailboat(t,Z), tspan, Z_init);

%     plot(t,z(:,1),'r-o',t,z(:,2),'g-d', ...
%         t,z(:,3),'b-s',t,z(:,4),'m-^',t,z(:,5),'k-*')
    plot(t,z(:,1),'r',t,z(:,2),'g', ...
        t,z(:,3),'b',t,z(:,4),'m',t,z(:,5),'k')
    hold on
    
    % update initial conditions for next iteration: x y theta v w
    for i=1:5
        Z_init(i) = z(end,i);
    end
    
    % update tspan
    tspan = tspan + 1;
    
    % CONTROLLER                    % todo!
    % update sail and rudder angle
    delta_s = delta_s + 0.05
    delta_r = delta_r + 0.1
    
    % update wind angle and magnitude
    
    a_tw = abs(a_tw) + 1
    psi_tw = abs(psi_tw) 
    
    if (j > 10)
        psi_tw = -1 * psi_tw
    end
    
    % re-compute parameters
    Wc_aw = [(a_tw * cos(psi_tw - theta) - v); ...
         (a_tw * sin(psi_tw - theta))]

    Wp_aw = [hypot(Wc_aw(2,:), Wc_aw(1,:)); ...
         atan2(Wc_aw(2,:), Wc_aw(1,:))] 
     
    a_aw = Wp_aw(1,:);    
    psi_aw = Wp_aw(2,:);     
    gs = -p4 * a_aw * sin(delta_s - psi_aw);     
    gr = -sign(psi_aw) * min(abs(pi - abs(psi_aw)), abs(delta_s));  
    
    
        
    
end

legend('x', 'y', 'theta', 'v', 'w')

function dZdt = sailboat(t,Z)

global p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 ...
       a_tw psi_tw delta_s delta_r Wc_aw Wp_aw gs gr % x y theta v w

dZdt = [ ...
        % x
        Z(4) * cos(Z(3)) + p1 * a_tw * cos(psi_tw); ...
        % y
        Z(4) * sin(Z(3)) + p1 * a_tw * sin(psi_tw); ...
        % theta
        Z(5); ...
        % v
        (gs * sin(delta_s) - gr * p11 * sin(delta_r) - p2 * Z(4)^2) / p9; ...
        % w
        (gs * (p6 - p7 * cos(delta_s)) - gr * p8 * cos(delta_r) - p3 ...
           * Z(5) * Z(4)) / p10; ...
        ];

% convert variable name to string
% source: http://stackoverflow.com/questions/11453165/matlab-get-string-containing-variable-name
% function out = varname(var)
%   out = inputname(1);
%   
% function out = legend_from_array(vals)
%       len = length(vals)
%       legendCell = [zeros(1,len)]
%       for j = 1:len
%           legendCell(j) %= inputname(vals(j))
%           vals(j)
%           inputname(vals(j))
%       end          

% function out = varname(var)
%   out = inputname(1);




