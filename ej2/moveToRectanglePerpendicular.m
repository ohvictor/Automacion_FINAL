function moveToRectanglePerpendicular(robot, targetPos, rectCenter, zHeight, qz, steps)
    % moveToRectanglePerpendicular: Mueve el brazo desde la posición de reposo hacia
    % una posición sobre el rectángulo, asegurando que el eje X del efector quede
    % perpendicular y el eje Z quede paralelo al plano del rectángulo en la posición final.
    %
    % robot: Objeto del robot definido con SerialLink.
    % targetPos: Vector [x, y] con la posición objetivo relativa dentro del rectángulo.
    % rectCenter: Vector [x, y, z] con el centro del rectángulo en el espacio.
    % zHeight: Altura mínima en Z en la que se desea la posición final del efector.
    % qz: Configuración de reposo del brazo.
    % steps: Número de pasos para interpolar suavemente el movimiento.

    % Paso 1: Mover el robot a la posición de reposo y hacer una pausa
    robot.plot(qz);
    pause(1); % Espera de 1 segundo en reposo

    % Paso 2: Calcular la posición global del objetivo en el espacio 3D
    globalTarget = [rectCenter(1) + targetPos(1), rectCenter(2) + targetPos(2), max(zHeight, rectCenter(3))];
    
    % Definir la orientación deseada para que el efector tenga el eje X perpendicular
    % al plano del rectángulo y el eje Z paralelo al mismo.
    orientation = trotz(0) * trotx(0); % Ajusta la orientación para cumplir con la condición

    % Crear la transformación objetivo con posición y orientación
    T_target = transl(globalTarget) * orientation;

    % Calcular la configuración articular para la posición objetivo usando cinemática inversa
    q_target = robot.ikine(T_target, qz, 'mask', [1 1 1 0 0 0]); % Fija posición y orientación deseada

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
