function moveToTarget(robot, qz, x_target, y_target, steps, rect_center, limits)
    % moveToTarget: Moves the robot from the resting position to a target position within the defined rectangle.
    % robot: The SerialLink object representing the robot.
    % qz: The resting position of the joints.
    % x_target, y_target: The X and Y coordinates of the target position (relative within the rectangle).
    % steps: Number of steps to reach from the starting to the final position.
    % rect_center: [x0, y0, z0] The center of the rectangle drawn with drawTablePaper.
    % limits: A matrix where each row is [min, max] for each joint's rotation limits.

    % Unpack the center coordinates of the rectangle
    x0 = rect_center(1);
    y0 = rect_center(2);
    z0 = rect_center(3);

    % Convert the relative target coordinates to absolute coordinates within the rectangle
    x_final = x0 + x_target;
    y_final = y0 + y_target;

    % Get the initial position (x0, y0, z0) from the resting configuration qz
    T_initial = robot.fkine(qz);
    z_start = T_initial.t(3); % Keep the initial Z position constant
    
    % Define the final position in terms of X, Y, Z
    z_final = z0; % Assume that the target is in the same plane as the initial position
    T_final = transl([x_final, y_final, z_final]);

    % Use inverse kinematics to find the joint configuration for the target position
    q_target = robot.ikine(T_final, 'mask', [1 1 0 0 0 0]); % Solve only for X, Y, ignoring orientation

    % Ensure the target configuration is within the limits
    q_target = enforceLimits(q_target, limits);

    % Generate a linear interpolation between the resting configuration and the target configuration
    q_trajectory = zeros(steps, length(qz));
    for j = 1:length(qz)
        q_trajectory(:, j) = linspace(qz(j), q_target(j), steps);
    end

    % Move the robot through each configuration in the trajectory
    for i = 1:steps
        robot.plot(q_trajectory(i, :));
        pause(0.05); % Pause between steps to create a smooth movement
    end
end

function q = enforceLimits(q, limits)
    % enforceLimits: Ensures that each joint configuration q respects the specified joint limits.
    % q: A vector of joint angles.
    % limits: A matrix where each row corresponds to [min, max] for each joint.
    
    for j = 1:length(q)
        % Apply the limits for each joint angle
        q(j) = max(limits(j, 1), min(limits(j, 2), q(j)));
    end
end
