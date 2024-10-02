    % if cosθ < 0
        % utilizar θ = θ + π; no deberia pasar porque "Theta spans the
        % range -pi/2 to pi/2"
    % else (cosθ > 0)
        % x = cosθ t
        % y = -sinθ t + y0
        % sinθ cosθ t - cosθ sinθ t + cosθ y0 = ρ
        % y0 = ρ/cosθ

        % t = 0             => x = 0        tmin1 = 0
        % t = WIDTH/cosθ    => x = WIDTH    tmax1 = WIDTH/cosθ

        % y = 0      => tA = y0/sinθ
        % y = HEIGHT => tB = (y0-HEIGHT)/sinθ
        % tmin2 = min(tA,tB); tmax2 = max(tA,tB)
        
        % tmin = max(tmin1,tmin2); tmax = min(tmax1,tmax2)
    % if senθ = 0 (linea horizontal)
        % x = t
        % y = ρ/cosθ
        % tmin = 0; tmax = WIDTH



    % if cosθ = 0 (linea vertical)
        % x = ρ/sinθ
        % y = t
        % tmin = 0; tmax = HEIGHT