%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Tolerancia:                                          %
%Las dimensiones de cada link podrian variar hasta un %
%5 %. Esta variacion aplica a todos los links         % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function currentPos = getPositionFromQz(robot, qz)
    % Calcula la posición cartesiana inicial a partir de qz
    inicialPos = robot.fkine(qz) % Matriz de transformación para la configuración qz
    currentPos = inicialPos.t % Extrae la posición XYZ desde initT
end