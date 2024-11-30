function manipulator(imagePath)
    % Solicitar valores de `z0` y `tol` al usuario
    disp('Por favor, ingrese los valores de los parámetros:');
    z0 = input('Posicion en Altura de la mesa (mm): ');
    tol = input('Tolerancia (Min:0 - Max:0.05): ');

    % Parámetros del robot
    x1 = 50; y1 = 144;
    x2 = 144; y2 = 0;
    x3 = 144; y3 = 0;

    % Ajuste de dimensiones con tolerancia
    y1 = y1 * (1 + tol);   
    x1 = x1 * (1 + tol);    
    x2 = x2 * (1 + tol);   
    x3 = x3 * (1 + tol);   
    xy1 = sqrt(y1^2 + x1^2);
    xy2 = sqrt(y2^2 + x2^2); 
    xy3 = sqrt(y3^2 + x3^2); 

    % Límite de giro de los joints
    offset_codo = atan2(y1, x1);
    qlim2 = [-pi/2 pi/2] - offset_codo;
    qlim3 = [-pi/2 pi/2] + offset_codo;
    rotation = [1,0,0;0,0,-1;0,1,0];

    % Construcción de Links
    L(1) = RevoluteMDH('d', 0, 'a', 0, 'alpha', 0);
    L(2) = RevoluteMDH('d', 0, 'a', 0, 'alpha', -pi/2, 'qlim', qlim2);
    L(3) = RevoluteMDH('d', 0, 'a', xy1, 'alpha', 0, 'qlim', qlim3);
    L(4) = RevoluteMDH('d', 0, 'a', xy2, 'alpha', 0);
    L(5) = RevoluteMDH('d', xy3, 'a', 0, 'alpha', pi/2);

    Tool = transl([0 0 100]); % Longitud del End Effector
    markerLength = 180; % Longitud del marcador
    qz = [0 -offset_codo offset_codo pi/2 0]; % Angulos iniciales de los joints

    % Construcción del robot
    robot = SerialLink(L, 'tool', Tool);
    robot.name = "WidowX Mark II";

    % Configuración del espacio de trabajo
    x0 = 400; y0 = 0; % Ubicación de la mesa
    width = 150; large = 200; % Dimensiones de la mesa
    createTablePaper(width, large, x0, y0, z0);

    % Inicialización del robot en teach mode
    robot.teach(qz);

    % Obtención de trayectoria desde la imagen
    [xinit, yinit, xend, yend] = getLine(imagePath);
    steps = 30;

    % Dibujo de trayectoria
    % 1. Mover al origen de la mesa y posicionar el marcador
    [currentPos, qz] = moveRobotToOrigin(robot, qz, x0, z0, markerLength, steps, rotation);

    % 2. Mover a la posición inicial de dibujo
    [currentPos, qz] = moveRobotArm(robot, qz, [xinit, yinit, currentPos(3)], steps, rotation);
    pause(2);

    % 3. Mover a la posición final de dibujo
    [currentPos, qz] = moveRobotArm(robot, qz, [xend, yend, currentPos(3)], steps, rotation);
    pause(2);

    % 4. Dibujar la línea de referencia
    hold on;
    drawLineOnPaper([xinit, yinit, currentPos(3)], [xend, yend, currentPos(3)], markerLength);

    disp('Proceso completado.');
end
