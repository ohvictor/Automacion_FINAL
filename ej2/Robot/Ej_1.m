% Creacion del brazo RRR

syms q1 q2 q3;

%Perturbacion
pert = 0.0;

%Limites de joints
qlim_deg = [0 360; 20 180-20; -127 0; 5 35 ];
qlim = qlim_deg * pi / 180;

messi = RobotInit(pert,qlim);

%messi.fkine([q1, q2, q3])

w = 150;
h = 200;
cx = 300;
cy = 0;

attack_cercano = -25;
attack_lejano = 0;

%q = messi.ikine((transl(cx+w/2,cy,0))*trotz(-90)*troty(90),  'mask', [1 1 1 0 0 1]);

q_cercano = messi.ikine((transl(cx-w/2,cy,0))*trotz(-90+attack_cercano),  'mask', [1 1 1 0 0 1]);
q_lejano = messi.ikine((transl(cx+w/2,cy+h/2,0))*trotz(-90+attack_lejano),  'mask', [1 1 1 0 0 1]);
%q_cercano_deg = q_cercano * 180 / pi;
%q_lejano_deg = q_lejano * 180 / pi;


%q_test = q;
%q_test(3) = q_cercano(3);
%q_test(4) = q_lejano(4);
messi.plot(q_cercano);
hold on;
plot_box('centre', [cx,0,0], 'size', [w,h], 'linewidth', 4);












