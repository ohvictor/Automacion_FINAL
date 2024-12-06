function plotSpace(limits, robot, degree_step, qz)
    step_sizes = deg2rad(degree_step);
    x = []; y = []; z = [];
    
    for q1 = limits(1,1):step_sizes(1):limits(1,2)
        for q2 = limits(2,1):step_sizes(2):limits(2,2)
            for q3 = limits(3,1):step_sizes(3):limits(3,2)
                for q4 = limits(4,1):step_sizes(4):limits(4,2)
                    for q5 = limits(5,1):step_sizes(5):limits(5,2)
                        q = [q1, q2, q3, q4, q5];
                        pos = robot.fkine(q).t; 
                        x = [x; pos(1)];
                        y = [y; pos(2)];
                        z = [z; pos(3)];
                    end
                end
            end
        end
    end

    % For fancy plotting
    xmin = min(x);
    xmax = max(x);
    xrange = xmax - xmin;
    c = jet(256);

    figure;
    hold on;
    for i = 1:length(x)
        % Para un ploteo lindo en RGB
        color_index = round((x(i) - xmin) * 255 / xrange);
        color_index = max(1, min(256, color_index));
        plot3(x(i), y(i), z(i), '.', 'MarkerSize', 2, 'Color', c(color_index, :));
    end
    
    robot.plot(qz);
    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');
    title('Reachable Workspace');
    grid on;
    axis equal;
    view(3);
    hold off;
end
