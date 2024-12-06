function [currentPos, qz] = moveRobotToOrigin(robot, qz, xmax, z0, markerLength, steps, rotation)
    %Mueve el robot al centro de la mesa a la altura del marcador
    currentPos = getPositionFromQz(robot, qz)'; % [x, y, z]
    finalPos = [xmax, currentPos(2), z0 + markerLength];
    [currentPos, qz] = moveRobotArm(robot, qz, finalPos, steps, rotation);

    pause(2);
end