data_num = 7;
% p_x = [0, 0 , 9.3 , 28.6 , 18 , 1.5, 0];
% v_x = [0, 0, 0.04448, 0, -0.0496, -0.01864, 0];
% t_x = [0, 12.2*20, 32.3*20, 50.0*20, 68.4*20, 85.5*20, 100.0*20];

% p_x = [0, 0 , 9.3 , 28.6 , 18 , 1.5, 0];
% v_x = [0, 0, 0.04448, 0, -0.0496, -0.01864, 0];
% t_x = [0, 200.0, 400.0, 600.0, 800.0, 1000.0, 1200];

p_x = [0, 0 ,     8.0 ,   15.6 ,  8 ,    1.5,     0];
v_x = [0, 0,      0.06448,0,     -0.0696, -0.01864, 0];
t_x = [0, 200.0,  400.0,  600.0,  800.0,  1000.0,  1200];

coefficient = struct('a3', cell(1,data_num), 'b2', cell(1,data_num), 'c1', cell(1,data_num), 'd0', cell(1,data_num));


for i = 1:data_num - 1
    p0 = p_x(i);
    v0 = v_x(i);
    
    p1 = p_x(i+1);
    v1 = v_x(i+1);
    T = t_x(i+1) - t_x(i);
    disp(T);
    coefficient(i).d0 = p0;
    coefficient(i).c1 = v0;
    coefficient(i).b2 = (3*p1 - v1*T - 2*v0*T - 3*p0) / (T^2);
    coefficient(i).a3 = (-2*p1 + v1*T + v0*T + 2*p0) / (T^3);   

end

time_step = 5;%ms
total_time = t_x(end);
via_point = struct('p', [], 'v', [], 't', []);
via_points = [];

for the_t_value = 0:time_step:total_time
    k = 1;
    while(the_t_value >= t_x(k) && k < length(t_x))
        k = k+1;
    end
    k = k - 1;
    dt = the_t_value - t_x(k);
    via_point.p = coefficient(k).a3 * dt * dt * dt + coefficient(k).b2 * dt * dt + coefficient(k).c1 * dt + coefficient(k).d0;
    via_point.v = 3 * coefficient(k).a3 * dt * dt + 2 * coefficient(k).b2 * dt + coefficient(k).c1;
    via_point.t = the_t_value;
    
    via_points = [via_points; via_point];
end


t = [via_points.t];
p = [via_points.p];
v = [via_points.v];

figure;

subplot(2,1,1);
plot(t, p);
hold on;  % Keep the current plot
plot(t_x, p_x, 'ro');  % Plot the points with red circles
title('Position vs Time');
xlabel('Time');
ylabel('Position');

subplot(2,1,2);
plot(t, v);
hold on;  % Keep the current plot
title('Velocity vs Time');
xlabel('Time');
ylabel('Velocity');


