clear variables
clc

%% Algunas constantes
offset_codo = atan2(144,50);
% qlim2 = [-pi/2 pi/2] - offset_codo;

%% Construcción de Links
L1 = RevoluteMDH(...
    'd',0,...
    'a',0,...
    'alpha',0);

L2 = RevoluteMDH(...
    'd',0,...
    'a',0,...
    'alpha',-pi/2,...
    'qlim',[-pi 0]);

%aux
L2b = PrismaticMDH(...
    'theta',pi/2,...
    'a',144,...
    'alpha',0,...
    'qlim',[0 0.1]);

L3 = RevoluteMDH(...
    'd',0,...
    'a',50,...
    'alpha',0,...
    'qlim',[-pi/2 pi/2]);

L4 = RevoluteMDH(...
    'd',0,...
    'a',144,...
    'alpha',0,...
    'qlim',[0 pi]);

L5 = RevoluteMDH(...
    'd',144,...
    'a',0,...
    'alpha',pi/2);

Tool = transl([0 0 200]);
qz = [0 -pi/2 0 0 pi/2 0];
%% Construcción del robot
robot = L1+L2+L2b+L3+L4+L5;
robot.name = "WidowX Mark II";

robot.teach(qz);