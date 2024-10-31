function createTablePaper(width, length, x0, y0, z0)
    % createTablePaper: Draws a rectangle in the XY plane resembling a simple wooden table
    % width: Width of the rectangle
    % length: Length of the rectangle
    % x0, y0, z0: Coordinates of the center of the rectangle
    
    % Calculate the coordinates of the rectangle's corners
    x1 = x0 - width / 2;
    x2 = x0 + width / 2;
    y1 = y0 - length / 2;
    y2 = y0 + length / 2;

    % Coordinates of the rectangle's vertices
    X = [x1, x2, x2, x1];
    Y = [y1, y1, y2, y2];
    Z = [z0, z0, z0, z0]; % Keep the rectangle in the plane at z0

    % Define a simple wood-like color (light brown)
    woodColor = [0.82, 0.71, 0.55]; % Light brown color for a subtle wood effect
    paper = fill3(X, Y, Z, woodColor);
    paper.FaceAlpha = 0.9; % Less transparent to look solid
    
    % Add a subtle dark border
    hold on;
    plot3([X X(1)], [Y Y(1)], [Z Z(1)], 'k-', 'LineWidth', 1); % Dark border
    hold off;
end
