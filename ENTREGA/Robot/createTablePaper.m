%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% createTablePaper: Draws a rectangle in the XY plane   %
% width: Width of the rectangle                         %
% length: Length of the rectangle                       %
% x0, y0, z0: Coordinates of the center of the rectangle%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   


function createTablePaper(width, length, x0, y0, z0)
    x1 = x0 - width / 2;
    x2 = x0 + width / 2;
    y1 = y0 - length / 2;
    y2 = y0 + length / 2;
    X = [x1, x2, x2, x1];
    Y = [y1, y1, y2, y2];
    Z = [z0, z0, z0, z0]; 

    woodColor = [0.82, 0.71, 0.55]; 
    paper = fill3(X, Y, Z, woodColor);
    paper.FaceAlpha = 0.9;
    hold on;
    plot3([X X(1)], [Y Y(1)], [Z Z(1)], 'k-', 'LineWidth', 1); 
    hold off;
end
