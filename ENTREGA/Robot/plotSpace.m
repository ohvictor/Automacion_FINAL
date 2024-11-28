function plotSpace(limits, robot, degree_step, qz)
    % limits: Max and Min for each joint in radians
    % robot: Robotic arm
    % degree_step: Degree Step size for each joint limit in degrees. This is useful
    % for better plotting performance
    % qz: Initial joint configuration

    step_sizes = deg2rad(degree_step);

    % These are reachable points in 3D Space
    x = []; y = []; z = [];

    %Program will iterate for each joint within the limits and increasing
    %in degree_step steps
    
    for q1 = limits(1,1):step_sizes(1):limits(1,2)
        for q2 = limits(2,1):step_sizes(2):limits(2,2)
            for q3 = limits(3,1):step_sizes(3):limits(3,2)
                for q4 = limits(4,1):step_sizes(4):limits(4,2)
                    for q5 = limits(5,1):step_sizes(5):limits(5,2)
                        % Calculate the end effector position using forward kinematics
                        q = [q1, q2, q3, q4, q5];
                        pos = robot.fkine(q).t; %As I have joint angles for all of them, I must use Forward Kinematics and I will have X,Y,Z
                        x = [x; pos(1)];
                        y = [y; pos(2)];
                        z = [z; pos(3)];
                    end
                end
            end
        end
    end

    % Get the minimum and maximum x-values for better color mapping
    xmin = min(x);
    xmax = max(x);
    xrange = xmax - xmin;

    % Define the color map with 256 colors
    c = jet(256);

    % Plot the reachable space with color based on the x position
    figure;
    hold on;
    for i = 1:length(x)
        % Map the x coordinate to a color index
        color_index = round((x(i) - xmin) * 255 / xrange);
        % Ensure the index is within valid bounds
        color_index = max(1, min(256, color_index));
        % Plot the point with the corresponding color
        plot3(x(i), y(i), z(i), '.', 'MarkerSize', 2, 'Color', c(color_index, :));
    end

    % Plot the robot in its initial configuration
    robot.plot(qz);
    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');
    title('Reachable Workspace');
    grid on;
    axis equal;
    view(3); % Ensure 3D view
    hold off;
end
