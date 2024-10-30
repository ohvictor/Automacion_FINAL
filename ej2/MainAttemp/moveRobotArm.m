function [currentPos, Ts, qLast] = moveRobotArm(robot, qz, finalPos, steps, rotation)
    % [currentPos, Ts, qLast] = moveRobotArm(robot, qz, finalPos, steps, rotation)
    % Mueve el robot desde la configuración inicial qz hasta la posición final deseada en 'steps' pasos en el espacio cartesiano
    
    % Calcular la posición inicial en el espacio cartesiano desde qz
    initT = robot.fkine(qz); % Calcula la matriz de transformación para la configuración inicial qz
    currentPos = initT.t; % Extrae la posición XYZ desde initT

    % Configurar la posición inicial y final con la rotación dada
    initT = [rotation, currentPos; 0, 0, 0, 1];
    finT = [rotation, finalPos'; 0, 0, 0, 1];

    % Generar una interpolación en el espacio cartesiano desde initT a finT
    TMove = ctraj(initT, finT, steps);

    % Convertir las matrices de transformación interpoladas en ángulos articulares
    qMove = zeros(steps, length(qz));
    for i = 1:steps
        qMove(i, :) = robot.ikine(TMove(:, :, i), 'mask', [1 1 1 1 0 1]);
    end

    % Visualizar la trayectoria
    robot.plot(qMove);
    
    % Actualizar la posición actual en el espacio cartesiano
    Ts = TMove(:, :, end); % Matriz de transformación final
    currentPos = Ts(1:3, 4)'; % Extrae la posición XYZ final
    qLast = qMove(end, :); % Última configuración de los ángulos de las articulaciones
end
