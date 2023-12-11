clear variables
clc
%% Construcción de Links
L1 = RevoluteMDH(...    & q1
    'd',0,...
    'a',0,...
    'alpha',0);

L2 = RevoluteMDH(...    % q2
    'd',0,...
    'a',0,...
    'alpha',-pi/2,...
    'qlim',[-pi 0]);

L2b = PrismaticMDH(...  % q3: Auxiliar
    'theta',pi/2,...
    'a',144,...
    'alpha',0,...
    'qlim',[0 0.1]);

L3 = RevoluteMDH(...    % q4
    'd',0,...
    'a',50,...
    'alpha',0,...
    'qlim',[-pi/2 pi/2]);

L4 = RevoluteMDH(...    % q5
    'd',0,...
    'a',144,...
    'alpha',0,...
    'qlim',[0 pi]);

L5 = RevoluteMDH(...    % q6
    'd',144,...
    'a',0,...
    'alpha',pi/2,...
    'qlim',[-pi*5/6 pi*5/6]);

Tool = transl([0 0 200]);
qz = [0 -pi/2 0 pi/2 0 0];

% Se ignora q3 porque es el prismático auxiliar
%% Construcción del robot
robot = L1+L2+L2b+L3+L4+L5;
robot.name = "WidowX Mark II";

robot.teach(qz);

qa = [0 -pi 0 pi/2 0 0];
robot.plot(qa);

%% Parámetros de control del robot
% Máscara: X,Y,Z    rX,rY,rZ
mask = [1 1 1 1 1 0];

%% Esquinas del área de dibujo
xi = -100;  xf = 100;   % Ancho: 200 mm
yi = 120;   yf = 270;   % Alto: 150mm. Alejado 120mm del centro
z = -130;               % Offset de la base. Altura regulable
theta = 180;            % La herramienta tiene Z hacia abajo
sqA = transl(yf,xi,z)*troty(theta);
sqB = transl(yf,xf,z)*troty(theta);
sqC = transl(yi,xf,z)*troty(theta);
sqD = transl(yi,xi,z)*troty(theta);

% q = robot.ikine(T,'mask',mask,'q0',qz);
qA = robot.ikine(sqA,'mask',mask,'q0',qz);
qB = robot.ikine(sqB,'mask',mask,'q0',qz);
qC = robot.ikine(sqC,'mask',mask,'q0',qz);
qD = robot.ikine(sqD,'mask',mask,'q0',qz);