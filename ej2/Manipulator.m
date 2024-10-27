%Clearing...

clear variables
clc

%% 1 - CREACION DEL ROBOT

%Dimensiones del brazo
%Estas variables definen las dimensiones del brazo robótico en términos de la distancia entre las articulaciones. Los valores de 𝑥 e 𝑦 
%representan la proyección de la distancia en el eje 𝑋 (horizontal) y en el eje Y (vertical).

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
% Se calculaa la distancia euclidiana entre las articulaciones 𝑍1, 𝑍2,𝑍3 y 𝑍4

xy1 = sqrt(y1^2+x1^2); %Distancia MOD entre Z1 y Z2
xy2 = sqrt(y2^2+x2^2); %Distancia MOD entre Z2 y Z3
xy3 = sqrt(y3^2+x3^2); %Distancia MOD entre Z3 y Z4

%% Límites de rotación

%offset_codo: Calcula el ángulo de inclinación del primer segmento (𝑍1 a 𝑍2) usando la función atan2, que devuelve el ángulo entre el eje 
%X y el vector resultante de las distancias x1 e 𝑦1
%qlim2 y qlim3: Ajustan los límites de rotación de las articulaciones 𝑍2 y 𝑍3 con base en el offset_codo. 
%Estos límites garantizan que las articulaciones no excedan ciertos rangos durante la simulación!!!

offset_codo = atan2(y1,x1);
qlim2 = [-pi/2 pi/2] - offset_codo;
qlim3 = [-pi/2 pi/2] + offset_codo;

%% Inyección de tolerancia
%Es un valor de tolerancia que permite ajustar ligeramente las dimensiones de los eslabones. 
%En este caso, tol es cero, por lo que no hay variación.
tol = 0.00;

y1 = y1*(1+tol);   % Altura en la imagen
x1 = x1*(1+tol);    % Longitud del codo

y2 = 0;
x2 = x2*(1+tol);   % Longitud del brazo 2

y3 = 0;
x3 = x3*(1+tol);   % Longitud del brazo 3

xy1 = sqrt(y1^2+x1^2);
xy2 = sqrt(y2^2+x2^2); %144
xy3 = sqrt(y3^2+x3^2); %144

%% Construcción de Links
%Cada articulación (L(1) a L(5)) se define como un link RevoluteMDH utilizando la convención de Denavit-Hartenberg modificada (MDH).

L(1) = RevoluteMDH('d',0,'a',0,'alpha',0);
L(2) = RevoluteMDH('d',0,'a',0,'alpha',-pi/2,'qlim', qlim2);
L(3) = RevoluteMDH('d',0,'a',xy1,'alpha',0,'qlim', qlim3);
L(4) = RevoluteMDH('d',0,'a',xy2,'alpha',0);
L(5) = RevoluteMDH('d',xy3,'a',0,'alpha',pi/2);

%Tool: Define la posición del efector final a 100 mm de distancia en el eje Z usando la función transl, que crea una matriz de transformación para la posición de la herramienta.
%qz: Define una configuración inicial para las articulaciones del robot, donde: 
%0: Articulación L(1) en posición neutral.
%-offset_codo: Compensa la inclinación inicial de  L(2).
%offset_codo: Compensa la inclinación inicial de L(3).
%pi/2: Posición del cuarto link.
%0: Articulación L(5) (sin rotación adicional).

Tool = transl([0 0 100]);
qz = [0 -offset_codo offset_codo pi/2 0];


%% Construcción del robot
%robot: Crea un objeto SerialLink que representa el brazo robótico, usando los eslabones definidos y la herramienta especificada.
%robot.name: Asigna un nombre al robot.
%robot.teach(qz): Abre una interfaz gráfica que permite mover manualmente las articulaciones del robot para ver cómo responde. Esto es útil para visualizar el comportamiento del robot y ajustar manualmente las configuraciones de cada articulación.

robot = SerialLink(L,'tool', Tool);
robot.name = "WidowX Mark II";

robot.teach(qz);

%% 2 - ESPACIO ALCANZABLE

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

% Llamada a la función para visualizar el espacio alcanzable
plotSpace(limits, robot, degree_step, qz);
