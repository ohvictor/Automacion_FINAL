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
        
%
%   TODO:
%- mostrar porque
%   t = max(max(input_image_mono))*0.7;
%  en lugar de 
%   t = otsu(input_image_mono);
%- poner en el PPT lo de borrador y lineas explicativas que borre
%
%

%   COMENTAR:
%- borre lo innecesarior
%- modifique los flags iniciales
%- puse algunos comentarios, y tengo TODOs para el PPT
%- cambie bucket_tool2 a bucket_tool