function [x_real, y_real] = normToTable(x_norm, y_norm, xmin, xmax, ymin, ymax)
    % x_norm: Valor X normalizado (entre 0 y 200)
    % y_norm: Valor Y normalizado (entre 0 y 150)
    % xmin, xmax: Límites del rectángulo en X
    % ymin, ymax: Límites del rectángulo en Y
    
    % Transformar X
    x_real = xmin + (xmax - xmin) * (x_norm / 200);
    
    % Transformar Y
    y_real = ymin + (ymax - ymin) * (y_norm / 150);
end