function drawLineOnPaper(startPos, endPos, markerLength)
    % startPos y endPos son vectores [x, y, z] de los puntos de inicio y fin
    
    lineColor = [0.3, 0.3, 0.6]; 
    lineWidth = 3;              
    
    plot3([startPos(1), endPos(1)], [startPos(2), endPos(2)], ...
          [startPos(3) - markerLength, endPos(3) - markerLength], ...
          '-', 'Color', lineColor, 'LineWidth', lineWidth);
    hold on; 
end
