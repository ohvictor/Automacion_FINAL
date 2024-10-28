function drawTrayectory(Ts,hojaAltura)

    drawTrayectory = Ts(1:3,4,:);
    X = drawTrayectory(1,:);
    Y = drawTrayectory(2,:);
    Z = hojaAltura + zeros(1,length(X));

    plot3(X,Y,Z,'Color', [1,0,0], 'MarkerSize', 3, 'LineWidth',2);
end