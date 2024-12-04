function output = bucket_tool(input_image, x, y, color)
    output = input_image;
    queue = zeros(0,2);
    
    % Si las coordenadas estan dentro de la imagen...
    if x >= 1 && x <= width(input_image) && y >= 1 && y <= height(input_image)
        % Obtengo el color original
        old_color = output(y,x,:);
        % Agrego el pixel inicial a la cola
        queue = [queue; x,y];

        % Mientras haya pixeles en la cola...
        while size(queue) ~= 0
            % Tomo el primer pixel de la cola
            current = queue(1,:);
            % y lo elimino de la cola
            queue = queue(2:end,:);
            % Si este pixel esta dentro de la imagen ...
            if current(1) >= 1 && current(1) <= width(input_image) && current(2) >= 1 && current(2) <= height(input_image)
                % Si este pixel es del color original 
                if output(current(2),current(1),:) == old_color
                    % Lo pinto con el color nuevo
                    output(current(2),current(1),:) = color;
                    % Y agrego los cuatro pixeles contiguos a la cola
                    queue = [queue; current(1)-1,current(2); current(1)+1,current(2); current(1),current(2)-1; current(1),current(2)+1];
                end
            end
        end
    end
end