x_init = 0; %[m]
y_init = 0; %[m]

x_target = 5; %[m]
y_target = 5; %[m]

x_vel = 1; %[m/s]
y_vel = 1; %[m/s]

target_reached = 0;
timestep = 0.1; %[s]

sample_no = 1;
x_robot(sample_no) = x_init;
y_robot(sample_no) = y_init;
timestamps(sample_no) = 0;
tol = 0.1; %[m]

while ~target_reached 
    %increase timestep
    sample_no =  sample_no + 1;

    %calcualte new postition
    x_robot(sample_no) = x_robot(sample_no - 1) + x_vel * timestep;
    y_robot(sample_no) = y_robot(sample_no - 1) + y_vel * timestep;
    %store timestep
    timestamps(sample_no) = timestamps(sample_no - 1) + timestep;    

    %check if target is reached
    if ((abs(x_robot(sample_no) - x_target) < tol) || (abs(y_robot(sample_no) - y_target) < tol))
        target_reached = 1;
    end

    %insert animation here
    %...
end

figure
plot(x_robot, y_robot);
%plot(x_robot, timestamps);
figure 
%plot(y_robot, timestamps);