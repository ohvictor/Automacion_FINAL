function [currentPos, Ts, qz] = moveRobotToOrigin(robot, qz, xmax, z0, markerLength, steps, rotation)

    % Obtener la posición inicial en el espacio cartesiano a partir de los ángulos articulares
    currentPos = getPositionFromQz(robot, qz)'; % [x, y, z]

    % Definir la posición final deseada
    finalPos = [xmax, currentPos(2), z0 + markerLength];

    % Mover el robot al destino con orientación definida
    [currentPos, Ts, qz] = moveRobotArm(robot, qz, finalPos, steps, rotation);

    pause(2);
end