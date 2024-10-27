function plot_robot_workspace(messi,qlim, N, xmin, xmax)
    c = jet;
    for n=1:1:N

        theta = [0 0 0 0];
        for m = 1:4
            theta(m) = qlim(m,1) + (qlim(m,2) - qlim(m,1)) * rand(1,1);
        end

        workspace_point = messi.fkine(theta);
        %coordenada X esta en [xmin xmax], la mapeo a [0, 255]:
        xrange = xmax - xmin;
        color_index = round((workspace_point.t(1)-xmin)*255/xrange);

        hold on;
        plot3(workspace_point.t(1),workspace_point.t(2),workspace_point.t(3),'b.','MarkerSize', 2, 'Color', c(color_index,:) );

    end
end

