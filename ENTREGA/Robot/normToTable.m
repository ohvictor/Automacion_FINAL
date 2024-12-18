function [x_robot, y_robot] = normToTable(x_table, y_table)
    x_robot_top_left = 475;  x_robot_bottom_right = 325;

    y_robot_top_left = 100;y_robot_bottom_right = -100;

    width = 200;large = 150;

    % Transformar coordenadas de Mesa Vision a Mesa Robot:
    y_robot = y_robot_top_left + (x_table / width) * (y_robot_bottom_right - y_robot_top_left);
    x_robot = x_robot_top_left + (y_table / large) * (x_robot_bottom_right - x_robot_top_left);
end
