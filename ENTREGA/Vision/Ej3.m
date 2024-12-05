%% LIMPIEZA DE VARIABLES

clear all
close all
clc

%% ELECCION DE GRAFICOS A VISUALIZAR

SHOW_INTERMEDIATE_RESULTS = true;

SHOW_LINES = true;
SHOW_TRANSFORMED = true;

SHOW_1D_LINE = true;
SHOW_LINE_EXTREMES = true;

%% LECTURA DE IMAGEN Y FILTRADO DE MARCOS

% IMAGEN ORIGINAL
input_image = iread('C:\Users\rovai\Documents\GitHub\Automacion_FINAL\ENTREGA\Vision\EntregaImages\Ejemplo2.png');

if SHOW_INTERMEDIATE_RESULTS
figure()
idisp(input_image);
end

% IMAGEN EN BLANCO Y NEGRO
input_image_mono = imono(idouble(input_image));

if SHOW_INTERMEDIATE_RESULTS
figure()
idisp(input_image_mono);
end

% EXTRACCION DE LINEAS DE MARCO
t = max(max(input_image_mono))*0.7;
input_image_th = (input_image_mono>t) | idilate(red_content(input_image),kcircle(5));
if SHOW_INTERMEDIATE_RESULTS
% A todos los trazos encontrados...
figure()
idisp(input_image_mono>t);
% ... se le borran los correspondientes al fibron rojo
figure()
idisp(idilate(red_content(input_image),kcircle(5)) & ~red_content(input_image));
% ... siendo el resultado :
figure()
idisp(input_image_th)
end

% ELIMINACION DE ZONAS EXTERIORES A LA HOJA
input_image_nobackground = input_image_th;

for col = 1:width(input_image_nobackground)
    % Pinto la fila de arriba
    if input_image_nobackground(1,col) == 0
        input_image_nobackground = bucket_tool(input_image_nobackground,1,col,1);
    end
    % Pinto la fila de abajo
    if input_image_nobackground(end,col) == 0
        input_image_nobackground = bucket_tool(input_image_nobackground,1,height(input_image_nobackground),1);
    end    
end

for row = 1:height(input_image_nobackground)
    % Pinto la columna de la izquierda
    if input_image_nobackground(row,1) == 0
        input_image_nobackground = bucket_tool(input_image_nobackground,row,1,1);
    end
    % Pinto la columna de la derecha
    if input_image_nobackground(row,end) == 0
        input_image_nobackground = bucket_tool(input_image_nobackground,row,width(input_image_nobackground),1);
    end
end

if SHOW_INTERMEDIATE_RESULTS
figure()
idisp(input_image_nobackground)
end

% AUMENTO DEL GROSOR DEL MARCO
input_image_filteredframe = ierode(input_image_nobackground,kcircle(2));

if SHOW_INTERMEDIATE_RESULTS
figure()
idisp(input_image_filteredframe)
end

%% ENCONTRANDO POSICIÓN DE LOS MARCOS

% ENCUENTRO LAS RECTAS QUE DEFINEN LOS MARCOS
hough = Hough(~input_image_filteredframe);
hough.houghThresh = 2/3;
hough.suppress = 20;

if SHOW_LINES
    figure();
    idisp(input_image_filteredframe);
    hough.plot
end

lines = hough.lines;

% ENCUENTRO LOS VERTICES QUE QUEDAN DEFINIDOS POR ESTAS RECTAS
valid_verteces = zeros(2,0);
% Por cada linea ...
for i = 1:width(lines)
    % ... y por cada una de las lineas restantes 
    % (es decir, por cada par de lineas distintas)...
    for j = i:width(lines)
        % Obtengo las lineas
        line1 = lines(i);
        line2 = lines(j);
        % Y sus parametros theta y rho
        theta1 = line1.theta;
        theta2 = line2.theta;
        rho1 = line1.rho;
        rho2 = line2.rho;

        % Calculo su interseccion resolviendo un sistema de ecuaciones
        % lineal
        A = [sin(theta1),cos(theta1);sin(theta2),cos(theta2)];
        b = [rho1;rho2];
        % Si la matriz A es inversible...
        if det(A) ~= 0
            % Obtengo la interseccion
            xy = A\b;
            x = xy(1);
            y = xy(2);
            % Si dicha interseccion esta dentro de la imagen
            if x >= 1 && x <= width(input_image) && y >= 1 && y <= height(input_image)
                % Lo agrego a la lista de vertices validos
                valid_verteces = [valid_verteces,[x;y]];

                if SHOW_LINES
                    hold on
                    plot(x,y,"o",'MarkerSize',15);
                    hold off
                end
            end
        end
    end
end


%% OBTENCION DE LA IMAGEN SIN PERSPECTIVA
    
% Definicion del tamaño de la nueva imagen (1 pixel por milimetro)
new_width = 200;
new_height = 150;

% Se calcula la posicion de cada vertice respecto al centro del
% cuadrilatero, y el angulo de dichas posiciones respecto al eje X
center = (sum(valid_verteces')/4)';
offsets = valid_verteces-center;
angles = atan2(offsets(2,:),offsets(1,:));
% Se recorren los vertices en sentido horario (empleando los angulos 
% calculados anteriormente)
ordered_verteces = [angles;valid_verteces];
ordered_verteces = sortrows(ordered_verteces')';
ordered_verteces = ordered_verteces(2:3,:);
% Se recuperan los cuatro vertices ordenados
a = ordered_verteces(:,1);
b = ordered_verteces(:,2);
c = ordered_verteces(:,4);
d = ordered_verteces(:,3);

% Algoritmo de transformacion mediante INTERP2
%
%   a---b               a'--b'
%   |   |      =>       |   |
%   c---d               c'--d'
%
% P(u',v') = [a+(b-a)(u'/200)](1-(v'/150)) + [c+(d-c)(u'/200)](v'/150)

[Uo,Vo] = imeshgrid(new_width,new_height);
[Ui,Vi] = imeshgrid(input_image);

U = (a(1)+(b(1)-a(1))*Uo/new_width).*(1-Vo/new_height) + ...
    (c(1)+(d(1)-c(1))*Uo/new_width).*(Vo/new_height);
V = (a(2)+(b(2)-a(2))*Uo/new_width).*(1-Vo/new_height) + ...
    (c(2)+(d(2)-c(2))*Uo/new_width).*(Vo/new_height);

% IMAGEN EN BLANCO Y NEGRO, SIN PERSPECTIVA
input_image_transformed = interp2(Ui,Vi,idouble(imono(input_image)),U,V);
if SHOW_TRANSFORMED
    figure()
    idisp(input_image_transformed);
end
% SEGMENTO ROJO, SIN PERSPECTIVA
input_line_transformed = ...
    iclose( interp2(Ui,Vi,idouble(imono(red_content(input_image))), ...
    U,V,'nearest'),kcircle(6));
if SHOW_TRANSFORMED
    figure()
    idisp(input_line_transformed);
end

%% DETERMINACION DE LOS PUNTOS QUE PERTENECEN A LA RECTA

% Se halla la recta a la que pertenece el segmento
line_hough = Hough(input_line_transformed);
line_hough.suppress = 20;
line_found = line_hough.lines;

% Se define la precision en pixeles del muestreo
RESOLUTION = 1;

if SHOW_TRANSFORMED
    figure()
    idisp(input_line_transformed);
    line_found.plot;
    hold on;
end

% Se extraen los parametros theta y rho de la recta
line_theta = line_found.theta;
line_rho = line_found.rho;

if(cos(line_theta) < 0)
    line_theta = line_theta - pi;
end

cos_theta = cos(line_theta);
sin_theta = sin(line_theta);
% Si la NO linea es vertical...
if cos_theta ~= 0
    y0 = line_rho/cos_theta;
    tmin1 = 0;
    tmax1 = new_width/cos_theta;

    % Si la NO linea es horizontal...
    if sin_theta ~= 0
        tA = y0/sin_theta;
        tB = (y0-new_height)/sin_theta;
        tmin2 = min(tA,tB);
        tmax2 = max(tA,tB);
    
        tmin = max(tmin1,tmin2);
        tmax = min(tmax1,tmax2);
    % Si la linea es horizontal...
    else
        tmin = tmin1;
        tmax = tmax1;
    end

    line_array = zeros(3,0);
    
    for t = tmin:RESOLUTION:tmax
        lx = round(cos_theta * t);
        ly = round(-sin_theta * t + y0);
        if SHOW_TRANSFORMED
            hold on
            plot(lx, ly, 's', 'markersize',2,'MarkerEdgeColor','red',...
            'MarkerFaceColor','red');
            hold off
        end
        if lx>=1 && lx<=new_width && ly>=1 && ly<= new_height
            line_array = [line_array, [lx;ly;input_line_transformed(ly,lx)]];
        end
    end

% Si la linea es vertical...
else 
    tmin = 0;
    tmax = HEIGHT;
    line_array = zeros(3,0);
    for t = tmin:RESOLUTION:tmax
        lx = round(line_rho/sin_theta);
        ly = round(t);
        if SHOW_TRANSFORMED
            hold on
            plot(lx, ly, 'o');
            hold off
        end
        if lx>=1 && lx<=new_width && ly>=1 && ly<= new_height
            line_array = [line_array, [lx;ly;input_line_transformed(ly,lx)]];
        end 
    end
end

%% DETERMINACION DE LOS PUNTOS INICIAL Y FINAL

% PUNTOS PERTENECIENTES A TODA LA RECTA
if SHOW_1D_LINE
    figure();
    plot(line_array(3,:));
end

% FILTRADO DE LOS VALORES SOBRE LA RECTA
filter = sum(kgauss(3));
filter_width = width(filter);
filtered_line = conv(filter, line_array(3,:));

filtered_line = filtered_line(ceil(filter_width/2) ...
    :end-floor(filter_width/2));

if SHOW_1D_LINE
    hold on;
    plot(filtered_line);
    hold off;
end

% Se calculan los extremos mediante el umbral de 0.5
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

% EXTREMOS DEL SEGMENTO
if SHOW_LINE_EXTREMES
    figure();
    
    idisp(input_line_transformed);
    hold on;
    plot(line_array(1,t_start), line_array(2,t_start),'o','markersize',10);
    plot(line_array(1,t_end), line_array(2,t_end),'x','markersize',10);
    hold off;
end
%% RESULTADO

x1 = line_array(1,t_start);
y1 = line_array(2,t_start);
x2 = line_array(1,t_end);
y2 = line_array(2,t_end);
