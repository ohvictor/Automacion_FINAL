function moveArm(robot, x_target, y_target, steps)
    % Mueve el brazo a una posición deseada (x_target, y_target) en el plano XY,
    % manteniendo el efector final apuntando hacia el eje Z con un eje X perpendicular al plano Z.
    %
    % Parámetros:
    %   robot: el objeto SerialLink que representa el brazo robótico.
    %   x_target: coordenada X deseada.
    %   y_target: coordenada Y deseada.
    %   steps: número de pasos para realizar el movimiento suave.

    % Posición inicial en el plano XY
    q_current = robot.getpos();
    T_current = robot.fkine(q_current);
    x_start = T_current.t(1);
    y_start = T_current.t(2);
    z_target = T_current.t(3);  % Mantener la altura actual del efector final

    % Crear una trayectoria en línea recta entre la posición inicial y la deseada
    x_traj = linspace(x_start, x_target, steps);
    y_traj = linspace(y_start, y_target, steps);
    z_traj = linspace(T_current.t(3), z_target, steps);

    % Definir la orientación deseada: el eje Z del efector apuntando hacia arriba (identidad en rotación)
    R_target = trotz(0) * trotx(0);  % Orientación fija hacia el eje Z

    % Generar la trayectoria para cada paso
    for i = 1:steps
        % Calcular la posición objetivo en cada paso de la trayectoria
        pos_target = [x_traj(i), y_traj(i), z_traj(i)];
        
        % Crear la matriz de transformación con la orientación fija
        T_target = transl(pos_target) * R_target;
        
        % Resolver la cinemática inversa para obtener las configuraciones articulares
        % usando la orientación deseada
        q_target = robot.ikine(T_target, q_current, 'mask', [1 1 1 0 0 0]);
        
        % Mover el brazo a la posición objetivo
        robot.animate(q_target);
        
        % Actualizar la configuración actual
        q_current = q_target;
        
        % Pausar ligeramente para suavizar el movimiento
        pause(0.05);
    end
end
