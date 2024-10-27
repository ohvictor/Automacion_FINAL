function robotEnzo(L1,L2,L3,L4,L5,Lp,hojaAncho,hojaLargo,hojaOrigen,hojaAltura,marcadorLargo,marcadorOffset,limTheta1,limTheta2,limTheta3,limTheta4,steps,imgInitPosXY,imgFinalPosXY)
    % DH
    L(1)=Link([0 L1 0 0]);
    L(2)=Link([0 0 0 pi/2]);
    L(3)=Link([0 0 Lp 0]);
    L(4)=Link([0 0 L4 0]);
    L(5)=Link([0 0 L5 0]);

    rotation = [1,0,0; 
                0,0,-1; 
                0,1,0];
    currentPos = [hojaOrigen, L1+marcadorLargo+marcadorOffset];
    T = [rotation, currentPos'; 0 0 0 1];

    Enzo = SerialLink(L);
    Enzo.name = 'Enzo';

    qTarget = Enzo.ikine(T, 'mask', [1 1 1 1 0 1]);
    Enzo.plot(qTarget)

    %% Dibujo Hoja
    hold on;
    dibujoHoja(hojaAncho, hojaLargo,hojaOrigen(1),hojaOrigen(2),hojaAltura);

    %% Espacio alcanzable 
    %plotEspacioAlcanzable(limTheta1,limTheta2,limTheta3,limTheta4,Lp,L1,L4,L5,Enzo,T);

    %% Vision
    %imgInitPos, imgFinalPos = VISION
    currentPos = [hojaOrigen, L1+marcadorLargo+marcadorOffset];

    %% Logica de movimiento
    check = checkTrajectory(imgInitPosXY,imgFinalPosXY,hojaAncho,hojaLargo,hojaOrigen);
    if (check == 1)
        % Me ubico espacialmente en la posicion inicial de la trayectoria
        if ( (currentPos(1) ~= imgInitPosXY(1)) && (currentPos(2) ~= imgInitPosXY(2)) ) 
            % Me ubico en la posicion inicial XY
            finalPos = [imgInitPosXY, L1+marcadorLargo+marcadorOffset];
            [currentPos,Ts] = moveRobot(Enzo,currentPos,finalPos,steps,rotation);
            % Bajo hasta llegar a la mesa de trabajo
            finalPos = [imgInitPosXY, L1+marcadorLargo];
            [currentPos,Ts] = moveRobot(Enzo,currentPos,finalPos,steps,rotation);

        else
            % Si mi posicion XY coincide, solamente bajo hasta la posicion de
            % trabajo
            finalPos = [imgInitPosXY, L1+marcadorLargo];
            [currentPos,Ts] = moveRobot(Enzo,currentPos,finalPos,steps,rotation);
        end

        % Una vez ubicado en la posicion inicial, comienzo a trazar la trayectoria
        if (currentPos(3)==(L1+marcadorLargo))
            finalPos = [imgFinalPosXY, L1+marcadorLargo];
            [currentPos,Ts] = moveRobot(Enzo,currentPos,finalPos,steps,rotation);
            hold on;
            drawTrayectory(Ts,L1);
        end
        
        % Termina de trazar la trayectoria, vuelvo a la posicion original
        finalPos = [hojaOrigen, L1+marcadorLargo+marcadorOffset];
        moveRobot(Enzo,currentPos,finalPos,steps,rotation);
    end 
    
end 










