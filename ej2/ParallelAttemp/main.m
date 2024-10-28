
%%
clc;
clear all;
close all;

%% Main
%   En la funcion main se hace la asignacion de parametros iniciales
%   para crear el robot, la mesa de trabajo, las dimensiones del
%   instrumento del EndEffector, los angulos limites de cada joint y por
%   ultimo los steps del robot
%% Path de la Imagen y el Gamma
IMAGE_PATH = "Recta3.png";
gamma = 4;

%% Parametros del robot (nombre: Enzo)
L1 = 130;
L2 = 144;
L3 = 50;
L4 = 144;
L5 = 144;
Lp = sqrt(L2^2+L3^2);

%% Parametros de la superficie de trabajo (Hoja)
hojaAncho = 200;
hojaLargo = 150;
hojaOrigen = [0,-350];
hojaAltura = L1;

%% Parametros del marcador (Herramienta del EndEffector)
marcadorLargo = 110;
marcadorOffset = 20;

%% Parametros de angulos limites de los joints
limTheta1 = 80;
limTheta2 = 80;
limTheta3 = 80;
limTheta4 = 80;

%% Parametro de la velocidad del robot
steps = 30;

%% Vision
%[imgInitPosXY, imgFinalPosXY] = robotvision(IMAGE_PATH, gamma);

%% Posicion inicial y final
 imgInitPosXY = [100,-275];
 imgFinalPosXY = [200,-200];

%% Creo el robot pasandole todos los parametros necesarios
robotEnzo(L1,L2,L3,L4,L5,Lp,hojaAncho,hojaLargo,hojaOrigen,hojaAltura,marcadorLargo,marcadorOffset,limTheta1,limTheta2,limTheta3,limTheta4,steps,imgInitPosXY,imgFinalPosXY);




