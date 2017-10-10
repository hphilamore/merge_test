% 
% [t,y] = ode45('rigid',[0 12],[0 1 1]);
% % plot(t,y(:,1),'-o',t,y(:,2),'-.')
% 
% plot(t,y,'-o')

A = 1;
B = 2;
tspan = [0 5];
y0 = [0 0.01];
[t,y] = ode45(@(t,y) odefcn(t,y,A,B), tspan, y0);