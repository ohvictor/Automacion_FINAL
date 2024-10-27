function plotSpace(limits, robot, degree_step, qz)
    % limits: Matrix of nx2 where n is the number of joints, each row is [min, max]
    % robot: SerialLink object of the robotic arm
    % granularity: Array of step sizes in degrees for each joint (e.g., [10, 30, 20, 15, 5])
    % qz: Initial joint configuration (e.g., [0 -offset_codo offset_codo pi/2 0])

    % Convert the step sizes to radians
    step_sizes = deg2rad(degree_step); % Convert each granularity value to radians

    % Initialize matrices to store reachable points
    x = [];
    y = [];
    z = [];

    % Create nested loops to iterate through each angle within joint limits
    for q1 = limits(1,1):step_sizes(1):limits(1,2)
        for q2 = limits(2,1):step_sizes(2):limits(2,2)
            for q3 = limits(3,1):step_sizes(3):limits(3,2)
                for q4 = limits(4,1):step_sizes(4):limits(4,2)
                    for q5 = limits(5,1):step_sizes(5):limits(5,2)
                        % Calculate the end effector position using forward kinematics
                        q = [q1, q2, q3, q4, q5];
                        pos = robot.fkine(q).t; % Get the position (x, y, z) of the end effector
                        % Store the points
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
    title('Reachable Workspace of the Robotic Arm with RGB Coloring');
    grid on;
    axis equal;
    view(3); % Ensure 3D view
    hold off;
end
