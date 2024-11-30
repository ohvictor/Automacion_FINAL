%% 1 - CREACION DEL ROBOT

clear variables
clc
%Definicion de Parametros del Robot y Espacio de Trabajo

%Distancias de Z1 a Z2
x1 = 50;    % Longitud del codo - Distancia en X
y1 = 144;   % Altura en la imagen - Distancia en Y
%Distancias de Z2 a Z3
x2 = 144;   % Longitud del brazo 2 - Distancia en X
y2 = 0;
%Distancias de Z3 a Z4 siendo Z4 el EE
x3 = 144;   % Longitud del brazo 3 - Distancia en X
y3 = 0;
%Distancias entre links
xy1 = sqrt(y1^2+x1^2); %Distancia MOD entre Z1 y Z2
xy2 = sqrt(y2^2+x2^2); %Distancia MOD entre Z2 y Z3
xy3 = sqrt(y3^2+x3^2); %Distancia MOD entre Z3 y Z4

% Límites de giro de los joints
offset_codo = atan2(y1,x1);             %angulo de inclinación de𝑍1 a 𝑍2
qlim2 = [-pi/2 pi/2] - offset_codo;     %limite rotacion z2
qlim3 = [-pi/2 pi/2] + offset_codo;     %limite rotacion z3
rotation = [1,0,0;0,0,-1;0,1,0];        %Matriz de rotacion

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Tolerancia:                                          %
%Las dimensiones de cada link podrian variar hasta un %
%5 %. Esta variacion aplica a todos los links         % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tol = 0.00;
y1 = y1*(1+tol);   
x1 = x1*(1+tol);    
y2 = 0;
x2 = x2*(1+tol);   
y3 = 0;
x3 = x3*(1+tol);   
xy1 = sqrt(y1^2+x1^2);
xy2 = sqrt(y2^2+x2^2); 
xy3 = sqrt(y3^2+x3^2); 

% Construcción de Links
L(1) = RevoluteMDH('d',0,'a',0,'alpha',0);
L(2) = RevoluteMDH('d',0,'a',0,'alpha',-pi/2,'qlim', qlim2);
L(3) = RevoluteMDH('d',0,'a',xy1,'alpha',0,'qlim', qlim3);
L(4) = RevoluteMDH('d',0,'a',xy2,'alpha',0);
L(5) = RevoluteMDH('d',xy3,'a',0,'alpha',pi/2);

Tool = transl([0 0 100]);                 %Longitud End Effector
markerLenght = 180;                       %Longitud del marcador 
qz = [0 -offset_codo offset_codo pi/2 0]; %Angulos Iniciales de los joint

% Construcción del robot
robot = SerialLink(L,'tool', Tool);
robot.name = "WidowX Mark II";

%Espacio de Trabajo
x0= 400; y0=0; z0=-130;                       %Ubicacion de la mesa
width=150;large=200;                         %Dimensiones de la mesa
xmin = x0 - width/2; xmax = x0 + width/2;    %Esquinas eje X de la mesa de dibujo
ymin = y0 - large/2; ymax = y0 + large/2;    %Esquinas eje y de la mesa de dibujo
createTablePaper(width, large, x0, y0, z0);

robot.teach(qz);

%% 2.1 - ESPACIO ALCANZABLE

% Definición de los límites (puedes ajustar según sea necesario)
limits = [
    -pi, pi;                                    % q1: Rotación completa de la base
    -pi/2 - offset_codo, pi/2 - offset_codo;    % q2: Ajustado por el offset del codo
    -pi/2 + offset_codo, pi/2 + offset_codo;    % q3: Ajustado por el offset del codo
    -pi/2, pi/2;                                % q4: Rotación de ±90°
    -pi, pi                                     % q5: Rotación completa del efector final
];

degree_step = [30, 20, 20, 20, 180];
qz = [0, -offset_codo, offset_codo, pi/2, 0];

plotSpace(limits, robot, degree_step, qz);