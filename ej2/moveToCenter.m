function moveToCenter(robot, qInit, rect_center, z_height, steps)
    % moveToCenter: Mueve el robot hasta el centro del rectángulo con el efector final paralelo al plano XY
    % y con el eje X del efector final alineado con el eje X del mundo.
    % robot: Objeto del robot
    % qInit: Configuración inicial de las articulaciones
    % rect_center: Coordenadas [x, y, z] del centro del rectángulo
    % z_height: Altura del efector final sobre el rectángulo
    % steps: Número de pasos para la interpolación suave
    
    % Posición objetivo sobre el centro del rectángulo a la altura deseada
    targetPos = [rect_center(1), rect_center(2), rect_center(3) + z_height];
    
    % Definir la orientación del efector final como alineada con el sistema de referencia global
    % Esto se hace utilizando la matriz de identidad (sin rotación)
    rotation = eye(3);
    
    % Matriz de transformación objetivo
    targetT = transl(targetPos) * r2t(rotation);
    
    % Resolver la cinemática inversa para obtener los ángulos articulares del objetivo
    qTarget = robot.ikine(targetT, 'mask', [1 1 1 0 0 1]);
    
    % Generar interpolación suave en el espacio articular
    qTrajectory = jtraj(qInit, qTarget, steps);
    
    % Visualizar la trayectoria
    robot.plot(qTrajectory);
end
