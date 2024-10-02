function output = bucket_tool2(input_image, x, y, color)
    output = input_image;
    queue = zeros(0,2);

    %disp('OUTSIDE');
    %disp(size(queue));
    
    if x >= 1 && x <= width(input_image) && y >= 1 && y <= height(input_image)
        old_color = output(y,x,:);
        queue = [queue; x,y];

        %disp('INSIDE1');
        %disp(size(queue));
        while size(queue) ~= 0
            %disp('INSIDE2');
            %disp((queue));
            current = queue(1,:);
            queue = queue(2:end,:);
            if current(1) >= 1 && current(1) <= width(input_image) && current(2) >= 1 && current(2) <= height(input_image)
               if output(current(2),current(1),:) == old_color
                    output(current(2),current(1),:) = color;
                    queue = [queue; current(1)-1,current(2); current(1)+1,current(2); current(1),current(2)-1; current(1),current(2)+1];
               end
            end
        end
    end
end