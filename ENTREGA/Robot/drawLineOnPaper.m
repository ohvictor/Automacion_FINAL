function drawLineOnPaper(startPos, endPos, markerLength)
    % startPos y endPos son vectores [x, y, z] de los puntos de inicio y fin
    
    % Define un color azul grisáceo suave y un grosor de línea sutil
    lineColor = [0.3, 0.3, 0.6]; % Azul grisáceo suave
    lineWidth = 3;               % Grosor de línea para darle elegancia
    
    % Dibuja la línea con el estilo especificado
    plot3([startPos(1), endPos(1)], [startPos(2), endPos(2)], ...
          [startPos(3) - markerLength, endPos(3) - markerLength], ...
          '-', 'Color', lineColor, 'LineWidth', lineWidth);
    hold on; % Mantiene el dibujo en el mismo gráfico
end
