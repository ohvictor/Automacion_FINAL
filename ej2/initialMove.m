function q_target = initialMove(robot, qz, z0, zoffset, limits, steps)
    % initialMove: Moves the robot to a position where the end effector is at z0 + zoffset.
    % Keeps q4 aligned parallel to the X-axis while allowing other joints to adjust.
    % robot: The SerialLink object representing the robot.
    % qz: The resting position of the joints.
    % z0: The height of the plane.
    % zoffset: Additional height above z0.
    % limits: A matrix where each row is [min, max] for each joint's rotation limits.
    % steps: Number of steps for smooth movement.

    % Get the initial position and orientation from the resting configuration qz
    T_initial = robot.fkine(qz);
    R_initial = T_initial.R; % Extract the orientation of the end effector
    currentPos = T_initial.t; % Extract the current position of the end effector

    % Define the target height as z0 + zoffset
    z_target = z0 + zoffset;
    
    % Create a new transformation matrix with the same X, Y, and updated Z position
    % Adjust the rotation to ensure q4 is aligned with the X-axis
    R_target = troty(pi/2); % Rotate about the Y-axis by 90 degrees to align q4 with X-axis
    T_target = transl([currentPos(1), currentPos(2), z_target]) * R_target;

    % Use inverse kinematics to find the joint configuration for the target position
    % Allow adjustment of multiple joints while keeping the orientation.
    q_target = robot.ikine(T_target, 'mask', [1 1 1 1 0 1], 'q0', qz, 'ilimit', 1000, 'tol', 1e-4);

    % Check if q_target is empty or contains NaN values (indicating failure to converge)
    if isempty(q_target) || any(isnan(q_target))
        error('Inverse kinematics did not converge to a solution. Adjust the target position or initial guess.');
    end

    % Ensure the target configuration is within the limits
    q_target = enforceLimits(q_target, limits);

    % Generate a linear interpolation between the resting configuration and the target configuration
    q_trajectory = zeros(steps, length(qz));
    for j = 1:length(qz)
        q_trajectory(:, j) = linspace(qz(j), q_target(j), steps);
    end

    % Move the robot through each configuration in the trajectory, checking that it stays above the minimum height
    for i = 1:steps
        % Get the transformation matrix for the current configuration of the end effector
        T_end_effector = robot.fkine(q_trajectory(i, :));
        z_effector = T_end_effector.t(3);

        % Ensure the end effector is at least 10 mm above the rectangle plane
        if z_effector < z0 + 10
            error('The trajectory attempts to place the end effector below the required height of z0 + 10 mm.');
        end

        % Check all links' positions for the current configuration
        for link_idx = 1:robot.n
            T_link = robot.A(1:link_idx, q_trajectory(i, :)); % Get transformation matrix for the current link
            z_link = T_link.t(3); % Extract the Z position of the link
            
            % Ensure each link position is above the rectangle plane
            if z_link < z0
                error('The trajectory attempts to place part of the robot below the rectangle plane.');
            end
        end

        % Plot the current configuration if it is safe
        robot.plot(q_trajectory(i, :));
        pause(0.01); % Pause between steps to create a smooth movement
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
