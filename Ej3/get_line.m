function [x1,y1,x2,y2] = get_line(input_path)
    x1 = 0;
    y1 = 0;
    x2 = 0;
    y2 = 0;

    SHOW_LINES = false;
    % LECTURA DE IMAGEN Y FILTRADO DE MARCOS

    input_image = iread(input_path);

    input_image_mono = imono(idouble(input_image));

    t = max(max(input_image_mono))*0.7;
    input_image_th = (input_image_mono>t) | idilate(red_content(input_image),kcircle(5));

    input_image_nobackground = input_image_th;

    for col = 1:width(input_image_nobackground)
        if input_image_nobackground(1,col) == 0
            input_image_nobackground = bucket_tool2(input_image_nobackground,1,col,1);
        end
        if input_image_nobackground(end,col) == 0
            input_image_nobackground = bucket_tool2(input_image_nobackground,1,height(input_image_nobackground),1);
        end    
    end

    for row = 1:height(input_image_nobackground)
        if input_image_nobackground(row,1) == 0
            input_image_nobackground = bucket_tool2(input_image_nobackground,row,1,1);
        end
        if input_image_nobackground(row,end) == 0
            input_image_nobackground = bucket_tool2(input_image_nobackground,row,width(input_image_nobackground),1);
        end
    end

    input_image_filteredframe = ierode(input_image_nobackground,kcircle(2));

    % ENCONTRANDO POSICIÓN DE LOS MARCOS

    hough = Hough(~input_image_filteredframe);%(1:2:end,1:2:end,:));%, 'nbins',[800,801]);
    hough.houghThresh = 2/3;
    hough.suppress = 20;

    lines = hough.lines;

    valid_verteces = zeros(2,0);
    for i = 1:width(lines)
        for j = i:width(lines)
            line1 = lines(i);
            line2 = lines(j);
            theta1 = line1.theta;
            theta2 = line2.theta;
            rho1 = line1.rho;
            rho2 = line2.rho;

            A = [sin(theta1),cos(theta1);sin(theta2),cos(theta2)];
            b = [rho1;rho2];
            if det(A) ~= 0
                xy = A\b;
                x = xy(1);
                y = xy(2);
                
                %disp(xy);
                if x >= 1 && x <= width(input_image) && y >= 1 && y <= height(input_image)
                    valid_verteces = [valid_verteces,[x;y]];

                    if SHOW_LINES
                        hold on
                        plot(x,y,"o");
                    end
                end
            end
            %valid_verteces = [valid_verteces;[i,j]];
        end
    end

    %   a---b               a'--b'
    %   |   |      =>       |   |
    %   c---d               c'--d'
    %
    % P(u',v') = [a+(b-a)(u'/200)](1-(v'/150)) + [c+(d-c)(u'/200)](v'/150)

    new_width = 200*2;
    new_height = 150*2;

    center = (sum(valid_verteces')/4)';
    offsets = valid_verteces-center;
    angles = atan2(offsets(2,:),offsets(1,:));

    ordered_verteces = [angles;valid_verteces];
    ordered_verteces = sortrows(ordered_verteces')';
    ordered_verteces = ordered_verteces(2:3,:);

    a = ordered_verteces(:,1);
    b = ordered_verteces(:,2);
    c = ordered_verteces(:,4);
    d = ordered_verteces(:,3);

    [Uo,Vo] = imeshgrid(new_width,new_height);
    [Ui,Vi] = imeshgrid(input_image);
    
    %ordered_valid_verteces = [sum(valid_verteces);valid_verteces;[1 2 3 4]];
    %ordered_valid_verteces = sortrows(ordered_valid_vertecesSSss')';
    %ordered_valid_verteces = valid_verteces(2:3,:);
        
    U = (a(1)+(b(1)-a(1))*Uo/new_width).*(1-Vo/new_height) + (c(1)+(d(1)-c(1))*Uo/new_width).*(Vo/new_height);
    V = (a(2)+(b(2)-a(2))*Uo/new_width).*(1-Vo/new_height) + (c(2)+(d(2)-c(2))*Uo/new_width).*(Vo/new_height);
    
    
    input_image_transformed = interp2(Ui,Vi,idouble(imono(input_image)),U,V);
    input_line_transformed = iclose(interp2(Ui,Vi,idouble(imono(red_content(input_image))),U,V,'nearest'),kcircle(6));

    % ENCONTRANDO RECTA, PUNTOS INICIAL Y FINAL

    line_hough = Hough(input_line_transformed);
    line_hough.suppress = 20;
    line_found = line_hough.lines;

    RESOLUTION = 1;

    % sinθ x + cosθ y = ρ
    % if cosθ = 0 => linea vertical
    % elif sinθ = 0 => linea horizontal
    % else => linea oblicua
        % sinθ x + cosθ y = ρ
        % tanθ x + y = ρ/cosθ
        % y = ρ/cosθ - tanθ x

    line_theta = line_found.theta;
    line_rho = line_found.rho;  

    if(cos(line_theta) < 0)
        line_theta = line_theta - pi;
    end


    cos_theta = cos(line_theta);
    sin_theta = sin(line_theta);
    if cos_theta ~= 0
        y0 = line_rho/cos_theta;
        tmin1 = 0;
        tmax1 = new_width/cos_theta;

        if sin_theta ~= 0
            tA = y0/sin_theta;
            tB = (y0-new_height)/sin_theta;
            tmin2 = min(tA,tB);
            tmax2 = max(tA,tB);
        
            tmin = max(tmin1,tmin2);
            tmax = min(tmax1,tmax2);
        else
            tmin = tmin1;
            tmax = tmax1;
        end

        line_array = zeros(3,0);
        
        for t = tmin:RESOLUTION:tmax
            lx = round(cos_theta * t);
            ly = round(-sin_theta * t + y0);
            if lx>=1 && lx<=new_width && ly>=1 && ly<= new_height
                line_array = [line_array, [lx;ly;input_line_transformed(ly,lx)]];
            end
        end

    else % linea vertical
        tmin = 0;
        tmax = HEIGHT;
        line_array = zeros(3,0);
        for t = tmin:RESOLUTION:tmax
            lx = round(line_rho/sin_theta);
            ly = round(t);
            if lx>=1 && lx<=new_width && ly>=1 && ly<= new_height
                line_array = [line_array, [lx;ly;input_line_transformed(ly,lx)]];
            end 
        end
    end

    filter = sum(kgauss(3));
    filter_width = width(filter);
    filtered_line = conv(filter, line_array(3,:));

    filtered_line = filtered_line(ceil(filter_width/2):end-floor(filter_width/2));

    t_start = 0;
    t_end = 0;

    for t_ = 1:(width(filtered_line)-1)

        if filtered_line(t_) < 0.5 && filtered_line(t_+1) >= 0.5
            t_start = t_+1;
        end
        
        if filtered_line(t_) >= 0.5 && filtered_line(t_+1) < 0.5
            t_end = t_;
        end

    end
    x1 = line_array(1,t_start);
    y1 = line_array(2,t_start);
    x2 = line_array(1,t_end);
    y2 = line_array(2,t_end);
end
