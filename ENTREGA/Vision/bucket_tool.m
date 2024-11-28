function output = bucket_tool(input_image, x, y, color)
    output = input_image;
    if x >= 1 && x <= width(input_image) && y >= 1 && y <= height(input_image)
        old_color = input_image(y,x,:);
        paint_at(output,x,y,old_color,color);
    end
    
end

function paint_at(image,x,y,old_color,new_color)
%output = image;
if x >= 1 && x <= width(image) && y >= 1 && y <= height(image)
    if image(y,x,:) == old_color
        %image(y,x,:) = new_color;
        change_pixel(image,x,y,new_color);
        disp(memory().MemUsedMATLAB);
        paint_at(image,x-1,y,old_color,new_color);
        paint_at(image,x+1,y,old_color,new_color);
        paint_at(image,x,y-1,old_color,new_color);
        paint_at(image,x,y+1,old_color,new_color);
    end
end
end

function change_pixel(image, x, y, new_color)
if x >= 1 && x <= width(image) && y >= 1 && y <= height(image)
    image(y,x,:) = new_color;
    if ~isempty(inputname(1))
        assignin('caller',inputname(1),image);
    end
end
end