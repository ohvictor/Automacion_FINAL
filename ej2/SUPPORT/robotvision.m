function [imgInitPos, imgFinalPos] = robotvision(imagepath,gamma)
close all,  clc

%% Preprocesamiento de imagen
imgen = imread(imagepath);
idisp(imgen)
title('Imagen original')
imcolor = imgen+igamm(imgen,gamma); %Corrección gamma, se eligió el exponente 4 para condiciones pobres de iluminación
% figure
% idisp(imcolor)

%% Detección de las esquinas

%Separación de bordes del resto de la imagen

greenthresh = 100; %Threshold de verde, valores laxos para distintas condiciones de iluminación.
cimagered = imcolor(:,:,1)<150;
cimagegreen = imcolor(:,:,2)>greenthresh;
cimageblue = imcolor(:,:,3)<150;
borderimg = cimagered&cimagegreen&cimageblue;
% figure
% idisp(borderimg) %Por si se desea visualizar pasos intermedios
%S = ones(3,3);  %Se prueba con distintos tipos de elementos estructurales 
S = kcircle(3);
borderimg = iclose(borderimg,S); %Prellenado de esquinas para no perder pixeles durante el filtrado
% figure
% idisp(borderimg)

S = kcircle(1);
borderimg = iopen(borderimg,S); %Filtrado de ruido
% figure
% idisp(borderimg)
%S = ones(10,10);
S = kcircle(5);
borderimg = iclose(borderimg,S); %Llenado de las esquinas
figure
idisp(borderimg)
title('Bordes de imagen')

imlin = Hough(borderimg); %Hallazgo de líneas en la imagen
SuppressAmt = 10; %Threshold inicial
while size(imlin.lines,2) > 4 %Filtrado hasta llegar a 4 líneas
        SuppressAmt = SuppressAmt + 5;
        imlin.suppress=SuppressAmt;
end

% figure
% idisp(borderimg)
% imlin.plot
% title('Bordes en perspectiva');
lines = imlin.lines;

HorLines = zeros (2,2); %Bordes Horizontales
HorCount = 1;
VerLines = zeros(2,2); %Bordes Verticales
VerCount = 1;

for i = 1:4
    if abs(lines(i).theta) < pi/4
        HorLines(HorCount,1) = lines(i).theta;
        HorLines(HorCount,2) = lines(i).rho;
        HorCount = HorCount + 1;
    else
        VerLines(VerCount,1) =lines(i).theta;
        VerLines(VerCount,2) =lines(i).rho;
        VerCount = VerCount + 1;
    end
end

HorLines = sortrows(HorLines,2,'ascend'); %1 = borde superior, 2 = borde inferior
VerLines = sortrows(VerLines,2,'ascend'); %1 = borde izquierdo, 2 = borde derecho

Intersect = zeros(4,2); %Puntos de intersección 1---2
                        %                       |   |
                        %                       3---4
ICounter = 1;

syms y1 y2 x
for i = 1:2 %Ubicación de los puntos de intersección de las rectas
    for j = 1:2
        y1 = -x*tan(HorLines(i,1))+HorLines(i,2)/cos(HorLines(i,1));
        y2 = -x*tan(VerLines(j,1))+VerLines(j,2)/cos(VerLines(j,1));
        Intersect(ICounter,1) = double(solve(y1 - y2 == 0,x));
        Intersect(ICounter,2) = double(subs(y1,'x',Intersect(ICounter,1)));
        ICounter = ICounter + 1;
        
    end
end

%% Transformación de coordenadas

% Se propone y = f(u,v) = auv + bu +cv + d ; x = f(u,v) = auv +bu +cv +d
% x = A*coefx | y = A*coefy
A = [Intersect(1,1)*Intersect(1,2) Intersect(1,1) Intersect(1,2) 1 ;...
    Intersect(2,1)*Intersect(2,2) Intersect(2,1) Intersect(2,2) 1 ;...
    Intersect(3,1)*Intersect(3,2) Intersect(3,1) Intersect(3,2) 1;...
    Intersect(4,1)*Intersect(4,2) Intersect(4,1) Intersect(4,2) 1];
x1 = [0 200 0 200]';
y1 = [-200 -200 -350 -350]';

coefx = A\x1; %coeficientes a b c d
coefy = A\y1;

%% Detección de la recta
redthresh = 80; %Threshold de rojo
cimagered = imcolor(:,:,1)>redthresh;
cimagegreen = imcolor(:,:,2)<80;
cimageblue = imcolor(:,:,3)<80;
lineimg = cimagered&cimagegreen&cimageblue;
% figure
% idisp(lineimg)
S = kcircle(1);
lineimg = iopen(lineimg,S); %Filtro el ruido
figure
idisp(lineimg)
title('Recta en perspectiva')
%end

litpixels = find(lineimg == 1); %Encuentro los pixeles de la recta
vsize = size(lineimg,1); 
usize = size(lineimg,2);
startpixel = litpixels(1); 
endpixel = litpixels(end); 
ustart = floor(startpixel/vsize); %Coordenadas pixel inicial
vstart = startpixel - ustart*vsize;
uend =  floor(endpixel/vsize); %Coordenadas pixel final
vend = endpixel - uend*vsize;

%% Transformación de la recta
Astart = [ustart*vstart ustart vstart 1];
Aend = [uend*vend uend vend 1];

imgInitPos = [Astart*coefx Astart*coefy];
imgFinalPos = [Aend*coefx Aend*coefy];

figure
plot([imgInitPos(1) imgFinalPos(1)], [imgInitPos(2) imgFinalPos(2)])
labels = {'Inicio','Fin'};
text([imgInitPos(1) imgFinalPos(1)], [imgInitPos(2) imgFinalPos(2)],labels)
grid on
axis([0 200 -350 -200]);
title('Recta a dibujar')

end
