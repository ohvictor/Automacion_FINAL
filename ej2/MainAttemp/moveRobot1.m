function [currentPos, Ts] = moveRobot1(Enzo, currentPos, finalPos, steps, rotation)
    % [currentPos, Ts] = moveRobot(Enzo, currentPos, finalPos, steps, rotation)
    % Esta función mueve el robot Enzo desde una posición inicial a una final en 'steps' pasos
    % utilizando una rotación específica.
    
    % Inicialización de la matriz de transformación inicial con rotación y posición
    initT = [rotation, currentPos'; 0, 0, 0, 1];
    % Obtener ángulos articulares para la posición inicial
    qInit = Enzo.ikine(initT, 'mask', [1 1 1 1 0 1]);

    % Configuración de la posición final con rotación y posición deseada
    finT = [rotation, finalPos'; 0, 0, 0, 1];
    % Obtener ángulos articulares para la posición final
    qFin = Enzo.ikine(finT, 'mask', [1 1 1 1 0 1]);

    % Generación de la trayectoria en el espacio cartesiano
    Ts = ctraj(initT, finT, steps);
    % Cálculo de los ángulos articulares para cada posición en la trayectoria
    qMove = Enzo.ikine(Ts, 'mask', [1 1 1 1 0 1]);
    % Visualización de la trayectoria
    Enzo.plot(qMove);

    % Actualizar posición actual
    currentPos = finalPos;
end
