function via_point = getPvFromFx(coefficient, t_x, the_t_value)
    % 初始化一个via_point结构体变量
    via_point = struct('p', [], 'v', [], 't', []);
    k = 1;

    if the_t_value == 0
        via_point.p = 0;
        via_point.v = 0;
        via_point.t = 0;
        return;
    end

    while the_t_value >= t_x(k)
        k = k + 1;
    end

    k = k - 1;

    % 计算时间点the_t_value和时间区间开始时间点的差值
    dt = the_t_value - t_x(k);

    % 需要计算的时间点the_t_value在第一个插值点的时间和最后一个插值点的时间内，采用对应时间区间的三次项系数计算得出PV值
    via_point.p = coefficient(k).a3 * dt^3 + coefficient(k).b2 * dt^2 + coefficient(k).c1 * dt + coefficient(k).d0;
    via_point.v = 3 * coefficient(k).a3 * dt^2 + 2 * coefficient(k).b2 * dt + coefficient(k).c1;
    via_point.t = the_t_value;

    return;
end
