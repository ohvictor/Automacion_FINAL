function dibujoHoja(ancho,largo,x0,y0,z0)
% dibujoHoja: dibuja los cuatro lados de la mesa en el dibujo 3D
%   ancho: ancho de la hoja
%   largo: largo de la hoja
%   x0,y0,z0: es la coordenada superior izquierda de la hoja
    
    color = [0, 1, 0];
	
	X = [x0, x0 + ancho, x0 + ancho, x0];
	Y = [y0, y0, y0 + largo, y0 + largo];
	Z = [z0, z0, z0, z0];
    
    hoja = fill3(X,Y,Z,[0, 0, 1]);
    hoja.FaceColor = color;
    hoja.FaceAlpha = 0.3;
    
end