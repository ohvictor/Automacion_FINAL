function draw_triangle(vertex, messi, traj_steps, tmax_edge, q_reposo, n_int_points)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    close all;
    
    
    
    vertex = [vertex; vertex(1,:)];
    n_vertex = length(vertex);  %vertices del poligono a dibujar
    n_intermediate_points = n_int_points;  
    n_pos = n_vertex + n_intermediate_points * (n_vertex-1) + 2;       %cantidad de posiciones que adopta el robot (incluye la de reposo inicial y final, los 3 vertices del triangulo, y las posiciones intermedias de los ejes)
    
    pos_q = ones(n_pos,messi.n);
    pos_q(1,:) = q_reposo;
    pos_q(n_pos,:) = q_reposo;
    
    trajs_q = zeros(n_pos,traj_steps, messi.n, 3);
    
    % Coordenadas en espacio joint de los vertices:
    
    for i = 1:n_vertex-1       
        for j = 0:n_intermediate_points
            y2 = vertex(i+1,2);
            x2 = vertex(i+1,1); 
            y1 = vertex(i,2);
            x1 = vertex(i,1);
            if x2 == x1
               x = x1;
               y = y1 + j/(n_intermediate_points+1)*(y2-y1);
            else
                pend = (y2-y1)/(x2-x1);
                x = x1 + j/(n_intermediate_points+1)*(x2-x1);
                y = pend * (x-x1) + y1;                
            end
                
            radius = sqrt(x^2 + y^2);
            %radio = 225 => ang_ataque = -25
            %radio = 388 => ang ataque = 0
            ang_ataque = (radius - 388) / 6.5;
            index = 1+(i-1)*(n_intermediate_points+1) + j;
            pos_q(index+1,:) = messi.ikine(transl(x, y, 0)*trotz(-90 + ang_ataque),  'mask', [1 1 1 0 0 1]);
        end
    end
    
    x = vertex(n_vertex,1);
    y = vertex(n_vertex,2);
    radius = sqrt(x^2 + y^2);
    %radio = 225 => ang_ataque = -25
    %radio = 388 => ang ataque = 0
    ang_ataque = (radius - 388) / 6.5;
    
    pos_q(n_pos-1,:) = messi.ikine(transl(x, y, 0)*trotz(-90 + ang_ataque),  'mask', [1 1 1 0 0 1]);

    t = 1.0/traj_steps : tmax_edge/traj_steps : tmax_edge;
    
%% Trayectorias entre vertices en espacio joint
    for i = 1:n_pos-1
        [trajs_q(i,:,:,1), trajs_q(i,:,:,2), trajs_q(i,:,:,3)] = jtraj(pos_q(i,:),pos_q(i+1,:),t);
    end
    [trajs_q(n_pos,:,:,1), trajs_q(n_pos,:,:,2), trajs_q(n_pos,:,:,3)] = jtraj(pos_q(n_pos,:),pos_q(1,:),t);
    
    %Ploteo trayectorias en espacio joint
    figure;
    tiledlayout(2,1);
    nexttile;
    q_total = [];

    t = 1.0/traj_steps : tmax_edge/traj_steps : tmax_edge*n_pos;    %para todos los graficos

    for k = 1:messi.n
        x = trajs_q(1,:,k,1);
        
        for i = 2:n_pos
            x = [x, trajs_q(i,:,k,1)];
        end
        q_total(k,:) = x;
        PlotTraj(t, x, 'Trayectoria en espacio joint',['Tiempo', 'Angulo'], ['tita_1','tita_2', 'tita_3', 'tita_4'], 1);
    end
    
    q_total = q_total';
    
    nexttile;
    for k = 1:messi.n
        x = trajs_q(1,:,k,2);
        for i = 2:n_pos
            x = [x, trajs_q(i,:,k,2)];
        end
        PlotTraj(t, x, 'Velocidad de joints',['Tiempo', 'Angulo'], ['tita_1','tita_2', 'tita_3', 'tita_4'], 1);
    end
    hold off;

%% Trayectorias entre vertices en espacio cartesiano

    figure;
    tiledlayout(2,1);
    
    nexttile;
    cart = transl(messi.fkine(q_total));  %pasar de joint a coordenadas cartesianas
    for k = 1:3 %uno por coordenada
        PlotTraj(t, cart(:,k), 'Posición del end effector en espacio cartesiano',['Tiempo(s)', 'Posición (mm)'], ['x','y', 'z'], 2);
    end
    
    nexttile;
    for k = 1:3
        cart_d = [diff(cart(:,k))' / (tmax_edge / traj_steps), 0];   %agrego 0 porque sino se pierde una muestra y explota todo :(
        PlotTraj(t, cart_d, 'Velocidad de end effector en espacio cartesiano',['Tiempo(s)', 'Velocidad(mm/s)'], ['x','y', 'z'], 2);
    end
    hold off;

    w = 150;
    h = 200;
    cx = 300;
    cy = 0;

    figure;
    plot_box('centre', [cx,0,0], 'size', [w,h], 'linewidth', 4);
    hold on;
    plot_poly(vertex');
    
    while(1)
        pause;
        messi.plot(q_total);
    end

end



%% Definiciones de función

function PlotTraj(t,x,plotTitle,labels,legends,index)
    figure(index)
    plot(t,x)
    title(plotTitle)
    %xlabel(labels(1));
    %ylabel(labels(2));
    grid on;
    hold on;
    %legend(legends(1),legends(2))
end
