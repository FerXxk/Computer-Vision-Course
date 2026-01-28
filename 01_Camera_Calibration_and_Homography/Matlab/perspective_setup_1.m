% Posición y orientación relativa de {C} respecto a {W}:
% Posición del origen de {C} respecto al sistema {W}:
wtc = [2,-1.8,3]';

% Orientación {C} respecto al sistema {W}. En general dada por sucesión de tres giros (convenio ZYX ejes móviles):
psi   = 0;  % Ángulo de rotación respecto a eje Z.
theta = 0 ;     % Ángulo de rotación respecto a eje Y'.
phi   =-3*pi/4; % Ángulo de rotación respecto a eje X''.

Rz = [ cos(psi) -sin(psi) 0
       sin(psi)  cos(psi) 0
           0         0    1 ];
      
Ry = [ cos(theta) 0 sin(theta)
           0      1    0
      -sin(theta) 0 cos(theta) ];           

Rx = [ 1    0        0
       0 cos(phi) -sin(phi) 
       0 sin(phi)  cos(phi) ];

wRc = Rz*Ry*Rx;

wTc = [wRc wtc; [0 0 0 1]];

cTw = inv(wTc);
cRw = cTw(1:3,1:3);
ctw = cTw(1:3,4);  
P1m = [0, 0, 0]';
P2m = [ 4, 0, 0]';
P3m = [ 4, 3, 0]';
P4m = [0, 3 ,0]';

wP1_m = [P1m;1];
wP2_m = [P2m;1];
wP3_m= [P3m;1];
wP4_m = [P4m;1];

p1_m = K * [cRw ctw] * wP1_m;
p2_m = K * [cRw ctw] * wP2_m;
p3_m = K * [cRw ctw] * wP3_m;
p4_m = K * [cRw ctw] * wP4_m;

p1m = p1_m(1:2)/p1_m(3);
p2m = p2_m(1:2)/p2_m(3);
p3m = p3_m(1:2)/p3_m(3);
p4m = p4_m(1:2)/p4_m(3);

pm1 = round (p1m);
pm2 = round (p2m);
pm3 = round (p3m);
pm4 = round (p4m);


mp=[0 4 4 0 0
    0 0 3 3 0
    0 0 0 0 0];
mp2=[2   2.5  2 1.5 2
     1  1.5   2  1.5  1
     0    0   0  0  0];

mp3=[pa1,pa2,pa3,pa4,pa1];

mp4=[pm1,pm2,pm3,pm4,pm1];