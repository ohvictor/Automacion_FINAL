%Clearing...

clear variables
clc

%% Dimensiones del brazo

%Distancias de Z1 a Z2

x1 = 50;    % Longitud del codo - Distancia en X
y1 = 144;   % Altura en la imagen - Distancia en Y

%Distancias de Z2 a Z3

x2 = 144;   % Longitud del brazo 2 - Distancia en X
y2 = 0;

%Distancias de Z3 a Z4 siendo Z4 el EE

x3 = 144;   % Longitud del brazo 3 - Distancia en X
y3 = 0;


%% Cálculo de Distancias entre links
xy1 = sqrt(y1^2+x1^2); %Distancia MOD entre Z1 y Z2
xy2 = sqrt(y2^2+x2^2); %Distancia MOD entre Z2 y Z3
xy3 = sqrt(y3^2+x3^2); %Distancia MOD entre Z3 y Z4

%% Límites de rotación
offset_codo = atan2(y1,x1);
qlim2 = [-pi/2 pi/2] - offset_codo;
qlim3 = [-pi/2 pi/2] + offset_codo;

%% Inyección de tolerancia
tol = 0.00;

y1 = y1*(1+tol);   % Altura en la imagen
x1 = x1*(1+tol);    % Longitud del codo

y2 = 0;
x2 = x2*(1+tol);   % Longitud del brazo 2

y3 = 0;
x3 = x3*(1+tol);   % Longitud del brazo 3

xy1 = sqrt(y1^2+x1^2);
xy2 = sqrt(y2^2+x2^2);
xy3 = sqrt(y3^2+x3^2);

%% Construcción de Links
L(1) = RevoluteMDH(...
    'd',0,...
    'a',0,...
    'alpha',0);

L(2) = RevoluteMDH(...
    'd',0,...
    'a',0,...
    'alpha',-pi/2,...
    'qlim', qlim2);

L(3) = RevoluteMDH(...
    'd',0,...
    'a',xy1,...
    'alpha',0,...
    'qlim', qlim3);

L(4) = RevoluteMDH(...
    'd',0,...
    'a',xy2,...
    'alpha',0);

L(5) = RevoluteMDH(...
    'd',xy3,...
    'a',0,...
    'alpha',pi/2);

Tool = transl([0 0 100]);
qz = [0 -offset_codo offset_codo pi/2 0];
%% Construcción del robot
robot = SerialLink(L,'tool', Tool);
robot.name = "WidowX Mark II";

robot.teach(qz);