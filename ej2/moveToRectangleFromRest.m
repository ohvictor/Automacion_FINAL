function moveToRectangleFromRest(robot, targetPos, rectCenter, zHeight, qz)
    % moveToRectangleFromRest: Mueve el brazo desde la posición de reposo hacia una
    % posición específica sobre el rectángulo, manteniendo el último link paralelo.
    %
    % robot: Objeto del robot definido con SerialLink.
    % targetPos: Vector [x, y] con la posición objetivo relativa dentro del rectángulo.
    % rectCenter: Vector [x, y, z] con el centro del rectángulo en el espacio.
    % zHeight: Altura en Z en la que se desea la posición final del efector.
    % qz: Configuración de reposo del brazo.

    % Paso 1: Mover el robot a la posición de reposo
    robot.plot(qz);
    pause(1); % Espera de 1 segundo en reposo

    % Paso 2: Calcular la posición global del objetivo en el espacio 3D
    globalTarget = [rectCenter(1) + targetPos(1), rectCenter(2) + targetPos(2), zHeight];
    
    % Definir la orientación deseada para mantener el último link paralelo al plano
    orientation = trotx(pi); % Rotación de 180° sobre el eje X para que el efector esté paralelo al plano

    % Crear la transformación objetivo con posición y orientación
    T_target = transl(globalTarget) * orientation;

    % Calcular las configuraciones articulares para alcanzar la posición deseada
    q = robot.ikine(T_target, 'mask', [1 1 1 0 0 1]); % Fija posición y orientación en Z para el plano

    % Paso 3: Mover el robot a la configuración calculada para la posición objetivo
    robot.plot(q);
end
