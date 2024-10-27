function [currentPos,Ts]=moveRobot(Enzo,currentPos,finalPos,steps,rotation)
    
    %rotation = [1,0,0; 0,0,-1; 0,1,0];
    
    % Obtengo posicion inicial
    initT = [rotation, currentPos'; 0 0 0 1];
    qInit = Enzo.ikine(initT, 'mask', [1 1 1 1 0 1]);

    % Obtengo posicion final
    finT = [rotation, finalPos'; 0 0 0 1];
    qFin = Enzo.ikine(finT, 'mask', [1 1 1 1 0 1]);

    %qMove = jtraj(qInit, qFin, steps);
    
    % Calculo de T para trayectoria lineal
    Ts = ctraj(initT, finT, steps);
    qMove = Enzo.ikine(Ts, 'mask', [1 1 1 1 0 1]);
    Enzo.plot(qMove)
    currentPos = finalPos;
end