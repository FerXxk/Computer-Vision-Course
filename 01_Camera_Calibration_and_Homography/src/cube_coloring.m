%% Renderizado mesa

Im_mesa = imread("imagenMesaMaderaColor1500.png");
[M1, N1, C] = size(Im_mesa);  % Dimensiones de la imagen de entrada

% Inicializar la imagen de salida en color (asumiendo que Im_mesa es una imagen en color)
Im_rend = 100 * ones(M, N, C, 'uint8');  % Imagen de salida en color, inicializada con un fondo gris claro

% Definir los puntos de la mesa y su plano de destino (fondo_2)

W=1501;
H=1000;

fondo_2 = mp4(:, 1:4);
mesa = [0 W W 0;
    0 0 H H];

% Calcular la homografía para proyectar la imagen de la mesa en el plano destino
Hm = homography_solver(mesa, fondo_2);

% Recorrer cada píxel de la imagen de la mesa
for i = 1:W
    for j = 1:H
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

imshow(Im_rend);
hold on;




aruco = [0 200 200  0 ;
    0  0  200 200];
for k=1:4
    switch k
        case 1
            Im_aruco= imread("aruco5.png");
            aruco_k=mpcc1(7:8,1:4);
        case 2
            Im_aruco= imread("aruco2.png");
            aruco_k=mpcc2(7:8,1:4);
        case 3
            Im_aruco= imread("aruco3.png");
            aruco_k=mpcc3(7:8,1:4);
        case 4
            Im_aruco= imread("aruco4.png");
            aruco_k=mpcc4(7:8,1:4);
    end
    Hc(:,:)=homography_solver(aruco,aruco_k); %Matriz de homografía

    for i=1:200
        for j=1:200
            rendC = Hc*[i,j,1]';
            xrendC = rendC(1)/rendC(3);
            xrend_C = round(xrendC);
            yrendC = rendC(2)/rendC(3);
            yrend_C = round(yrendC);
            iC(i,j) = Im_aruco(j,i);

            if xrend_C > 0 && xrend_C < N+1 && yrend_C > 0 && yrend_C < M+1
                if sum(Im_aruco(j,i,:))==0
                    switch k
                        case 1
                            Im_rend(yrend_C, xrend_C,:) = [0,0,150];
                        case 2
                            Im_rend(yrend_C, xrend_C,:) = [150,0,0];
                        case 3
                            Im_rend(yrend_C, xrend_C,:) = [150,150,0];
                        case 4
                            Im_rend(yrend_C, xrend_C,:) = [0,150,0];
                    end

                else
                    Im_rend(yrend_C, xrend_C,:) = Im_aruco(j,i,:);
                end

            end
        end
    end
end
imshow(Im_rend);


