function currentPos = getPositionFromQz(robot, qz)
    % Calcula la posición cartesiana inicial a partir de qz
    inicialPos = robot.fkine(qz) % Matriz de transformación para la configuración qz
    currentPos = inicialPos.t % Extrae la posición XYZ desde initT
end