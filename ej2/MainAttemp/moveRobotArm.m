function [currentPos, Ts] = moveRobotArm(robot, qz, finalPos, steps, rotation)
    % [currentPos, Ts] = moveRobot(robot, qz, finalPos, steps, rotation)
    % Mueve el robot desde la configuración inicial qz hasta la posición final deseada en 'steps' pasos
    
    % Calcular la posición inicial en el espacio cartesiano desde qz
    initT = robot.fkine(qz); % Calcula la matriz de transformación para la configuración de reposo qz
    currentPos = initT.t; % Extrae la posición XYZ desde initT

    % Configuración de la posición inicial con rotación y posición deseada
    initT = [rotation, currentPos; 0, 0, 0, 1];
    
    % Calcular los ángulos articulares para la posición final
    finT = [rotation, finalPos'; 0, 0, 0, 1];
    qFin = robot.ikine(finT, 'mask', [1 1 1 1 0 1]);

    % Generar una interpolación suave en el espacio articular desde qz a qFin
    qMove = jtraj(qz, qFin, steps);
    
    % Visualizar la trayectoria
    robot.plot(qMove);
    
    % Actualizar la posición actual en el espacio cartesiano
    Ts = robot.fkine(qMove);
    currentPos = finalPos;
end
