function [x_real, y_real] = normToTable(x_norm, y_norm)

    x0= 400; y0=0; z0=0;  
    width=150;large=200;                         %Dimensiones de la mesa
    xmin = x0 - width/2; xmax = x0 + width/2;    %Esquinas eje X de la mesa de dibujo
    ymin = y0 - large/2; ymax = y0 + large/2;
    
    % Transformar X
    x_real = xmin + (xmax - xmin) * (x_norm / 200);
    
    % Transformar Y
    y_real = ymin + (ymax - ymin) * (y_norm / 150);
end