function drawTablePaper(width, length, x0, y0, z0)
    % drawTablePaper: Draws a rectangle in the XY plane on the 3D plot
    % width: Width of the rectangle
    % length: Length of the rectangle
    % x0, y0, z0: Coordinates of the center of the rectangle
    
    % Calculate the coordinates of the rectangle's corners
    x1 = x0 - width/2;
    x2 = x0 + width/2;
    y1 = y0 - length/2;
    y2 = y0 + length/2;

    % Coordinates of the rectangle's vertices
    X = [x1, x2, x2, x1];
    Y = [y1, y1, y2, y2];
    Z = [z0, z0, z0, z0]; % Keep the rectangle in the plane at z0

    % Draw the rectangle with a semi-transparent color
    color = [1, 1, 0]; % Green
    paper = fill3(X, Y, Z, color);
    paper.FaceAlpha = 0.3; % Adjust transparency
end
