function [X_next] = simStep(X, U, dt)
    % simple 4th order Runge-Kutta method <-- check this
    k1 = continuousDynamics(X,U);
    k2 = continuousDynamics(X+k1*dt/2,U);
    k3 = continuousDynamics(X+k2*dt/2,U);
    k4 = continuousDynamics(X+k3*dt,U);
    
    X_next = X + (k1 + 2*k2 + 2*k3 + k4)*dt/6; 
end