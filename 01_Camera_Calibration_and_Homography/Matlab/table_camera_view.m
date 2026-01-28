% Parámetros intrínsecos de la cámara ignorando la distorsión:
f = 0.0042;
N=1500;
M=1000;
u0 = N/2;
v0 = M/2;
w=0.00496;
h=0.00352;
rho_x = w/N;
rho_y = h/M;
fx = f/rho_x;
fy = f/rho_y;
s = 0;  % Skew.


% Matriz de parámetros intrínsecos:
K = [ fx   s*fx  u0
       0    fy   v0
       0     0    1 ];  



% Se puede verificar que la forma rápida de invertir una matriz de transformación es correcta:
%cTw - [wRc', -wRc'*wtc; [0 0 0 1]];

% Dibujo camara



% Proyección del aruco a la imagen:
Pa1 = [2, 1, 0]';
Pa2 = [ 2.5, 1.5, 0]';
Pa3 = [ 2, 2, 0]';
Pa4 = [1.5, 1.5 ,0]';

wP1_ = [Pa1;1];
wP2_ = [Pa2;1];
wP3_ = [Pa3;1];
wP4_ = [Pa4;1];

p1_ = K * [cRw ctw] * wP1_;
p2_ = K * [cRw ctw] * wP2_;
p3_ = K * [cRw ctw] * wP3_;
p4_ = K * [cRw ctw] * wP4_;

p1 = p1_(1:2)/p1_(3);
p2 = p2_(1:2)/p2_(3);
p3 = p3_(1:2)/p3_(3);
p4 = p4_(1:2)/p4_(3);

pa1 = round (p1);
pa2 = round (p2);
pa3 = round (p3);
pa4 = round (p4);

% Proyección del marco a la imagen:

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

figure(2); 
% plot3(mp(1,:),mp(2,:),mp(3,:)); hold on;
% plot3(mp2(1,:),mp2(2,:),mp2(3,:));

plot(mp3(1,:),mp3(2,:)); hold on;
plot(mp4(1,:),mp4(2,:)); 



% Dibujamos marco exterior a la imagen, atendiendo a que el rango va de columnas es [1..N] y de filas [1..M]:
plot([0,0,N+1,N+1,0],[0,M+1,M+1,0,0],'Color','k', 'LineWidth',2);
hold off;

set(gca,'YDir', 'reverse');
