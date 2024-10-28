function moveToRectangleSmooth(robot, targetPos, rectCenter, zHeight, qz, steps)
    % moveToRectangleSmooth: Mueve el brazo desde la posición de reposo hacia
    % una posición sobre el rectángulo, con el efector final paralelo y sin
    % ir por debajo del plano definido en Z.
    %
    % robot: Objeto del robot definido con SerialLink.
    % targetPos: Vector [x, y] con la posición objetivo relativa dentro del rectángulo.
    % rectCenter: Vector [x, y, z] con el centro del rectángulo en el espacio.
    % zHeight: Altura mínima en Z en la que se desea la posición final del efector.
    % qz: Configuración de reposo del brazo.
    % steps: Número de pasos para interpolar suavemente el movimiento.

    % Paso 1: Mover el robot a la posición de reposo
    robot.plot(qz);
    pause(1); % Espera de 1 segundo en reposo

    % Paso 2: Calcular la posición global del objetivo en el espacio 3D
    globalTarget = [rectCenter(1) + targetPos(1), rectCenter(2) + targetPos(2), max(zHeight, rectCenter(3))];
    
    % Orientación deseada para mantener el efector paralelo al plano
    orientation = trotx(pi); % Rotación de 180° sobre el eje X

    % Crear la transformación objetivo con posición y orientación
    T_target = transl(globalTarget) * orientation;

    % Calcular la configuración articular para la posición objetivo usando cinemática inversa
    q_target = robot.ikine(T_target, qz, 'mask', [1 1 1 0 0 1]); % Fija posición y orientación en Z para el plano

    % Paso 3: Generar una trayectoria suave desde la posición de reposo hasta el objetivo
    q_trajectory = jtraj(qz, q_target, steps); % Interpolación de configuraciones

    % Paso 4: Ejecutar la trayectoria interpolada
    for i = 1:steps
        % Verificar que el efector no esté por debajo de la altura mínima en Z
        current_position = robot.fkine(q_trajectory(i, :)).t;
        if current_position(3) < zHeight
            warning('Movimiento cancelado: el efector está intentando ir por debajo de la altura del plano.');
            break;
        end

        % Mover el robot al siguiente punto en la trayectoria
        robot.plot(q_trajectory(i, :));
        pause(0.05); % Pausa para suavizar el movimiento
    end
end
