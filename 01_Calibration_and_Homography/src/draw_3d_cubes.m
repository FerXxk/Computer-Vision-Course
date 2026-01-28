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