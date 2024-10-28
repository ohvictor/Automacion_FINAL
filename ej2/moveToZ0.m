function moveToZ0(robot, targetPos)
    % moveToZ0: Mueve el brazo robótico a la posición Z0 deseada, asegurando
    % que el último link esté paralelo al plano XY.
    %
    % robot: Objeto del robot definido con SerialLink.
    % targetPos: Vector [x, y, z] con la posición objetivo en el plano.

    % Definir orientación deseada para que el efector esté paralelo al plano
    % Esto implica una orientación con el eje Z del efector perpendicular al plano
    orientation = trotx(pi); % Rotación de 180° sobre el eje X para dejar paralelo al plano
    
    % Posición objetivo con orientación
    T_target = transl(targetPos) * orientation;

    % Calcular la configuración articular usando cinemática inversa
    q = robot.ikine(T_target, 'mask', [1 1 1 0 0 1]); % Fija posición y orientación en el plano

    % Mover el robot a la configuración calculada
    robot.plot(q);
end
