function plotEspacioAlcanzable(theta1,theta2,theta3,theta4,Lp,L1,L4,L5,Enzo,T)
    % Defino los valores limites de theta1,theta2,theta3,theta4 para el
    % ploteo
    th1 = linspace(-double(theta1),double(theta1),double(theta1))*pi/180;
    th2 = linspace(-double(theta2),double(theta2),10.0)*pi/180;
    th3 = linspace(-double(theta3),double(theta3),10.0)*pi/180;
    th4 = linspace(-double(theta4),double(theta4),40.0)*pi/180;            
    [theta1,theta2,theta3,theta4] = ndgrid(th1,th2,th3,th4);

%     xM = L5*((81129638414606686663546605165575*cos(theta1 + theta2 + theta3 + theta4))/162259276829213363391578010288128 + (81129638414606676728031405122553*cos(theta2 - theta1 + theta3 + theta4))/162259276829213363391578010288128) + L4*((81129638414606686663546605165575*cos(theta1 + theta2 + theta3))/162259276829213363391578010288128 + (81129638414606676728031405122553*cos(theta2 - theta1 + theta3))/162259276829213363391578010288128) + Lp*((81129638414606676728031405122553*cos(theta1 - theta2))/162259276829213363391578010288128 + (81129638414606686663546605165575*cos(theta1 + theta2))/162259276829213363391578010288128);
%     yM = L4*((81129638414606686663546605165575*sin(theta1 + theta2 + theta3))/162259276829213363391578010288128 - (81129638414606676728031405122553*sin(theta2 - theta1 + theta3))/162259276829213363391578010288128) - (L5*(81129638414606676728031405122553*sin(theta2 - theta1 + theta3 + theta4) - 81129638414606686663546605165575*sin(theta1 + theta2 + theta3 + theta4)))/162259276829213363391578010288128 + Lp*((81129638414606676728031405122553*sin(theta1 - theta2))/162259276829213363391578010288128 + (81129638414606686663546605165575*sin(theta1 + theta2))/162259276829213363391578010288128);
%     zM = L1 + L4*sin(theta2 + theta3) + Lp*sin(theta2) + L5*sin(theta2 + theta3 + theta4);
    
    xM = L5*((0.5*cos(theta1 + theta2 + theta3 + theta4)) + (0.5*cos(theta2 - theta1 + theta3 + theta4))) + L4*((0.5*cos(theta1 + theta2 + theta3)) + (0.5*cos(theta2 - theta1 + theta3))) + Lp*((0.5*cos(theta1 - theta2)) + (0.5*cos(theta1 + theta2)));
    yM = L4*((0.5*sin(theta1 + theta2 + theta3)) - (0.5*sin(theta2 - theta1 + theta3))) - (L5*(0.5*sin(theta2 - theta1 + theta3 + theta4) - 0.5*sin(theta1 + theta2 + theta3 + theta4))) + Lp*((0.5*sin(theta1 - theta2)) + (0.5*sin(theta1 + theta2)));
    zM = L1 + L4*sin(theta2 + theta3) + Lp*sin(theta2) + L5*sin(theta2 + theta3 + theta4);
    figure();
    qTarget = Enzo.ikine(T, 'mask', [1 1 1 1 0 1]);
    cla;
    plot3(xM(:),yM(:),zM(:),'o')
    hold on;
    Enzo.plot(qTarget)
end