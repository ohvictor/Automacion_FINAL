% checkTrajectory
%
% input:
%   - imgInitPosXY = posicion inicial en XY de la trayectoria
%   - imgFinalPosXY = posicion final en XY de la trayectoria
%   - hojaAncho = ancho en el eje X de la hoja
%   - hojaLargo = largo en el eje Y de la hoja
%   - hojaOrigen = vector XY con la posicion origen de la hoja
%
% output:
%   - check = devuelve un booleano indicando si la trayectoria esta dentro
%             de la hoja o no

function check=checkTrajectory(imgInitPosXY,imgFinalPosXY,hojaAncho,hojaLargo,hojaOrigen)

    % Posiciones del espacion de trabajo
    % 0 < x < 200
    % -350 < y < -200
    
    % Chequeo eje X e Y de posicion inicial
    if( (imgInitPosXY(1)>=hojaOrigen(1)) && (imgInitPosXY(1)<=hojaAncho) )
       if ( (imgInitPosXY(2)>=hojaOrigen(2)) && (imgInitPosXY(2)<=(-hojaLargo)) )
           check = 1;
       end
    else
        check = 0;
        disp("La posicion inicial esta fuera de la hoja de trabajo")
    end
    
    % Chequeo eje X e Y de posicion final
    if( (imgFinalPosXY(1)>=hojaOrigen(1)) && (imgFinalPosXY(1)<=hojaAncho) )
       if ( (imgFinalPosXY(2)>=hojaOrigen(2)) && (imgFinalPosXY(2)<=(-hojaLargo)) )
           check = 1;
       end
    else
        check = 0;
        disp("La posicion final esta fuera de la hoja de trabajo")
    end

end