% Función para dibujar una línea en el plano de dibujo
function drawLineOnPaper(startPos, endPos,paintHeight)
    % startPos y endPos son vectores [x, y, z] de los puntos de inicio y fin
    plot3([startPos(1), endPos(1)], [startPos(2), endPos(2)], [startPos(3)-paintHeight, endPos(3)-paintHeight], 'k-', 'LineWidth', 2);
    hold on; % Mantiene el dibujo en el mismo gráfico
end