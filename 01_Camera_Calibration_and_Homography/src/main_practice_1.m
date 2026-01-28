
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

%% Posición y orientación relativa de {C} respecto a {W}:
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

% Se puede verificar que la forma rápida de invertir una matriz de transformación es correcta:
%cTw - [wRc', -wRc'*wtc; [0 0 0 1]];

% Dibujo camara


eje=DrawFrame(wTc,3,1)

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

%axis([-50,N+50,-50,M+50]);

% Dibujamos marco exterior a la imagen, atendiendo a que el rango va de columnas es [1..N] y de filas [1..M]:
plot([0,0,N+1,N+1,0],[0,M+1,M+1,0,0],'Color','k', 'LineWidth',2);
hold off;

set(gca,'YDir', 'reverse');


%% Renderizado mesa
Im_mesa= imread("wooden_table_grayscale.png");
fondo_2=mp4(:,1:4);
mesa = [0 626 626  0 ;
    0  0  417 417];
Hm(:,:)=HomographySolve(mesa,fondo_2); %Matriz de homografía

Im_rend=100*ones(M,N);
for i=1:626
    for j=1:417
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

%% Renderizado cubo
Im_aruco= imread("aruco.png");
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




%% Dibujo 3D
figure();
plot3(mp(1,:),mp(2,:),mp(3,:)); hold on;
%plot3(mp2(1,:),mp2(2,:),mp2(3,:));hold on;

DrawFrame(eye(4),3,1)
DrawFrame(wTc,3,1)


% Coordenadas de los vértices del cubo
vertices = 0.2*[
    0 0 0;  % Vértice 1
    1 0 0;  % Vértice 2
    1 1 0;  % Vértice 3
    0 1 0;  % Vértice 4
    0 0 1;  % Vértice 5
    1 0 1;  % Vértice 6
    1 1 1;  % Vértice 7
    0 1 1   % Vértice 8
    ];

% Define las aristas del cubo usando los índices de los vértices
aristas = [
    1 2; 2 3; 3 4; 4 1;  % Aristas de la base inferior
    5 6; 6 7; 7 8; 8 5;  % Aristas de la base superior
    1 5; 2 6; 3 7; 4 8   % Aristas verticales
    ];

offset=[1,1,0; 2,2,0 ;2,1,0;3,2.5,0];

vertices1=vertices+offset(1,:);
vertices2=vertices+offset(2,:);
vertices3=vertices+offset(3,:);
vertices4=vertices+offset(4,:);

% Dibuja el cubo usando plot3

hold on;

for i = 1:size(aristas, 1)
    % Extrae los puntos de inicio y fin de cada arista

    punto11 = vertices1(aristas(i, 1), :);
    punto21 = vertices1(aristas(i, 2), :);
    punto12 = vertices2(aristas(i, 1), :);
    punto22 = vertices2(aristas(i, 2), :);
    punto13 = vertices3(aristas(i, 1), :);
    punto23 = vertices3(aristas(i, 2), :);
    punto14 = vertices4(aristas(i, 1), :);
    punto24 = vertices4(aristas(i, 2), :);

    % Dibuja la arista
    plot3([punto11(1), punto21(1)], [punto11(2), punto21(2)], [punto11(3), punto21(3)], 'b-', 'LineWidth',2);
    plot3([punto12(1), punto22(1)], [punto12(2), punto22(2)], [punto12(3), punto22(3)], 'b-', 'LineWidth',2);
    plot3([punto13(1), punto23(1)], [punto13(2), punto23(2)], [punto13(3), punto23(3)], 'b-', 'LineWidth',2);
    plot3([punto14(1), punto24(1)], [punto14(2), punto24(2)], [punto14(3), punto24(3)], 'b-', 'LineWidth',2);
end



% Dibujar las ruedas en dos esquinas de la base inferior del cubo
radio_rueda = 0.05;  % Radio de la rueda
n_puntos = 50;  % Número de puntos para dibujar el círculo

% Coordenadas de las dos esquinas de la base inferior
ruedas_vertices1 = [vertices1(1, :)+[0 0.1 0.05]; vertices1(2, :)+[0 0.1 0.05]];
ruedas_vertices2 = [vertices2(1, :)+[0 0.1 0.05]; vertices2(2, :)+[0 0.1 0.05]];
ruedas_vertices3 = [vertices3(1, :)+[0 0.1 0.05]; vertices3(2, :)+[0 0.1 0.05]];
ruedas_vertices4 = [vertices4(1, :)+[0 0.1 0.05]; vertices4(2, :)+[0 0.1 0.05]];


wTc1=[eye(3) (offset(1,:)+[0.1 0.1 0.1])'; [0 0 0 1]];
wTc2=[eye(3) (offset(2,:)+[0.1 0.1 0.1])'; [0 0 0 1]];
wTc3=[eye(3) (offset(3,:)+[0.1 0.1 0.1])'; [0 0 0 1]];
wTc4=[eye(3) (offset(4,:)+[0.1 0.1 0.1])'; [0 0 0 1]];


ejescubo1=DrawFrame(wTc1,2,0.3);
ejescubo2=DrawFrame(wTc2,2,0.3);
ejescubo3=DrawFrame(wTc3,2,0.3);
ejescubo4=DrawFrame(wTc4,2,0.3);
%
for r=1:4
    switch r
        case 1
            ruedas_vertices=ruedas_vertices1;
        case 2
            ruedas_vertices=ruedas_vertices2;
        case 3
            ruedas_vertices=ruedas_vertices3;
        case 4
            ruedas_vertices=ruedas_vertices4;
    end

    for j = 1:2
        % Genera el círculo para la rueda en el plano xy
        theta = linspace(0, 2*pi, n_puntos);
        y_rueda = radio_rueda * cos(theta) + ruedas_vertices(j, 2);
        z_rueda = radio_rueda * sin(theta) + ruedas_vertices(j, 3);
        x_rueda = ones(1, n_puntos) * ruedas_vertices(j, 1);  % Altura en Z

        % Dibuja la rueda
        fill3(x_rueda, y_rueda, z_rueda, 'k-', 'LineWidth', 2); hold on; % Rueda en color negro


        switch r
            case 1
                if(j==1)
                    ruedas11(:,1:3) = [x_rueda; y_rueda; z_rueda]';
                else
                    ruedas12(:,1:3) = [x_rueda; y_rueda; z_rueda]';
                end
            case 2
                if(j==1)
                    ruedas21(:,1:3) = [x_rueda; y_rueda; z_rueda]';
                else
                    ruedas22(:,1:3) = [x_rueda; y_rueda; z_rueda]';
                end
            case 3
                if(j==1)
                    ruedas31(:,1:3) = [x_rueda; y_rueda;z_rueda]';
                else
                    ruedas32(:,1:3) = [x_rueda; y_rueda; z_rueda]';
                end
            case 4
                if(j==1)
                    ruedas41(:,1:3) = [x_rueda; y_rueda; z_rueda]';
                else
                    ruedas42(:,1:3) = [x_rueda; y_rueda; z_rueda]';
                end

        end

    end

end


%% Renderizado cubo
Im_aruco= imread("aruco.png");
cubo_1=mpc1(:,1:4);
cubo_2=mpc2(:,1:4);
cubo_3=mpc3(:,1:4);
cubo_4=mpc4(:,1:4);
aruco = [0 756 756  1 ;
    0  0  756 756];
Hc1(:,:)=homography_solver(aruco,cubo_1);
%Matriz de homografía
Hc2(:,:)=HomographySolve(aruco,cubo_2); %Matriz de homografía
Hc3(:,:)=homography_solver(aruco,cubo_3);
%Matriz de homografía
Hc4(:,:)=homography_solver(aruco,cubo_4);
%Matriz de homografía

for i=1:756
    for j=1:756
        rendC = Hc1*[i,j,1]';
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
for i=1:756
    for j=1:756
        rendC = Hc2*[i,j,1]';
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
for i=1:756
    for j=1:756
        rendC = Hc3*[i,j,1]';
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
for i=1:756
    for j=1:756
        rendC = Hc4*[i,j,1]';
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

%%

Im_mesa = imread("wooden_table_color.png");
[M1, N1, C] = size(Im_mesa);  % Dimensiones de la imagen de entrada

% Inicializar la imagen de salida en color (asumiendo que Im_mesa es una imagen en color)
Im_rend = 100 * ones(M, N, C, 'uint8');  % Imagen de salida en color, inicializada con un fondo gris claro

% Definir los puntos de la mesa y su plano de destino (fondo_2)
fondo_2 = mp4(:, 1:4);
mesa = [0 626 626 0;
    0 0 417 417];

% Calcular la homografía para proyectar la imagen de la mesa en el plano destino
Hm = homography_solver(mesa,fondo_2);

% Recorrer cada píxel de la imagen de la mesa
for i = 1:626
    for j = 1:417
        % Aplicar la homografía
        rendM = Hm * [i, j, 1]';
        xrendM = rendM(1) / rendM(3);
        yrendM = rendM(2) / rendM(3);

        % Redondear las coordenadas proyectadas
        xrend = round(xrendM);
        yrend = round(yrendM);

        % Comprobar que las coordenadas proyectadas estén dentro de los límites de Im_rend
        if xrend > 0 && xrend <= N && yrend > 0 && yrend <= M
            for c = 1:C  % Iterar sobre cada canal de color
                Im_rend(yrend, xrend, c) = Im_mesa(j, i, c);
            end
        end
    end
end

% Mostrar la imagen proyectada
figure();
imshow(Im_rend);
hold on;
xlabel("Eje horizontal [pix]");
ylabel("Eje vertical [pix]");
grid on;


