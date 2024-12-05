function [x_robot, y_robot] = normToTable(x_table, y_table)
    % Coordenadas de las esquinas del rectángulo en el sistema del robot
    x_robot_top_left = 475;   % X de la esquina superior izquierda
    x_robot_bottom_right = 325; % X de la esquina inferior derecha

    y_robot_top_left = 100;   % Y de la esquina superior izquierda
    y_robot_bottom_right = -100; % Y de la esquina inferior derecha

    % Dimensiones del rectángulo de la mesa imaginaria
    width = 200; % Ancho de la mesa imaginaria (eje X)
    large = 150; % Largo de la mesa imaginaria (eje Y)

    % Transformar coordenadas:
    % - Mapear eje X de la mesa imaginaria al eje Y del robot
    y_robot = y_robot_top_left + (x_table / width) * (y_robot_bottom_right - y_robot_top_left);

    % - Mapear eje Y de la mesa imaginaria al eje X del robot
    x_robot = x_robot_top_left + (y_table / large) * (x_robot_bottom_right - x_robot_top_left);
end
