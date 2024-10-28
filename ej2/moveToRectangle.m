function moveToRectangle(robot, x_target, y_target, z_target, steps)
    % Move the robotic arm smoothly to a position above the rectangle plane
    % with the X-axis of the end effector perpendicular to the plane

    % Definir la pose objetivo con orientación precisa
    % El eje X del efector final será perpendicular al plano Z=0, y el eje Z apunta hacia abajo
    targetPose = transl(x_target, y_target, z_target) * troty(-pi/2) * trotz(pi);

    % Obtener la configuración actual del brazo
    q_current = robot.getpos();

    % Calcular la configuración objetivo usando cinemática inversa
    q_target = robot.ikine(targetPose, 'mask', [1 1 1 0 0 0]); 

    % Validar si se encontró una configuración válida
    if isempty(q_target)
        error('No se encontró una configuración válida para la posición especificada.');
    end

    % Generar una interpolación entre la configuración actual y la configuración objetivo
    q_trajectory = jtraj(q_current, q_target, steps);

    % Recorrer cada punto de la trayectoria interpolada para realizar el movimiento suave
    for i = 1:steps
        robot.plot(q_trajectory(i, :));  % Mover el robot al siguiente punto en la trayectoria
        pause(0.05);  % Ajustar el tiempo de pausa para controlar la velocidad del movimiento
    end
end
