% Usar ruta relativa al script para mayor robustez
scriptDir = fileparts(mfilename('fullpath'));

% Grupo de cuatro vértices:
% P1 = [0, 0, 0]';
% P2 = [ 0, 4, 0]';
% P3 = [ 3, 4, 0]';
% P4 = [3, 0 ,0]';

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

% Posición y orientación relativa de {C} respecto a {W}:
% Posición del origen de {C} respecto al sistema {W}:

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




% Renderizado mesa
Im_mesa = imread(fullfile(scriptDir, '..', 'repository', 'wooden_table_grayscale_large.png'));

W=1501;
H=1000;

fondo_2 = mp4(:, 1:4);
mesa = [0 W W 0;
    0 0 H H];

Hm(:,:)=HomographySolve(mesa,fondo_2); %Matriz de homografía

Im_rend=100*ones(M,N);
for i=1:W
    for j=1:H
        rendM = Hm*[i,j,1]';
        xrendM = rendM(1)/rendM(3);
        xrend = round(xrendM);
        yrendM = rendM(2)/rendM(3);
        yrend = round(yrendM);
        iM(i,j) = Im_mesa(j,i);
        if xrend > 0 && xrend < N+1 && yrend > 0 && yrend < M+1
            Im_rend(yrend, xrend) = iM(i,j);
        end
    end
end
figure()
imshow(uint8(Im_rend)); hold on;
xlabel("Eje horizontal [pix]");
ylabel("Eje vertical [pix]");grid on;

% Renderizado cubo
Im_aruco = imread(fullfile(scriptDir, '..', 'repository', 'aruco.png'));
cubo_2=mp3(:,1:4);
aruco = [0 756 756  0 ;
    0  0  756 756];
Hc(:,:)=HomographySolve(aruco,cubo_2); %Matriz de homografía

for i=1:756
    for j=1:756
        rendC = Hc*[i,j,1]';
        xrendC = rendC(1)/rendC(3);
        xrend_C = round(xrendC);
        yrendC = rendC(2)/rendC(3);
        yrend_C = round(yrendC);
        iC(i,j) = Im_aruco(j,i);

        if xrend_C > 0 && xrend_C < N+1 && yrend_C > 0 && yrend_C < M+1
            Im_rend(yrend_C, xrend_C) = iC(i,j);
        end
    end
end
imshow(uint8(Im_rend)); hold off;