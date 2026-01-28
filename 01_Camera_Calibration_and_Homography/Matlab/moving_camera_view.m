x1=0;x2=0;x3=0;x4=0;
y1=0;y2=0;y3=0;y4=0;
angle1=0;angle2=0;angle3=0;angle4=0;
figure(1)
for n=1:50
    cla;




    v1= randi([0, 10])/100; v2= randi([0, 5])/100; v3= randi([0, 20])/100; v4= randi([0, 15])/100;
    anglei1= randi([-10,10]); anglei2= randi([-5,15]); anglei3= randi([-5,20]); anglei4= randi([-10,20]);
    angle1=angle1+anglei1; angle2=angle2+anglei2; angle3=angle3+anglei3; angle4=angle4+anglei4;


    if(x1>3.8-offset(1,1)||x1<0.2-offset(1,1)||y1<0.2-offset(1,2)||y1>2.8-offset(1,2))
        v1=-v1;
    end

    if(x2>3.8-offset(2,1)||x2<0.2-offset(2,1)||y2<0.2-offset(2,2)||y2>2.8-offset(2,2))
        v2=-v2;
    end

    if(x3>3.8-offset(3,1)||x3<0.2-offset(3,1)||y3<0.2-offset(3,2)||y3>2.8-offset(3,2))
        v3=-v3;
    end

    if(x4>3.8-offset(4,1)||x4<0.2-offset(4,1)||y4<0.2-offset(4,2)||y4>2.8-offset(4,2))
        v4=-v4;
    end
    if(abs(x1-x2)<0.1||abs(y1-y2)<0.1)
        v2=-v2;  v1=-v1;
    end
    if(abs(x1-x3)<0.1||abs(y1-y3)<0.1)
        v3=-v3;  v1=-v1;
    end

    if(abs(x1-x4)<0.1||abs(y1-y4)<0.1)
        v4=-v4;  v1=-v1;
    end

    if(abs(x2-x3)<0.1||abs(y3-y2)<0.1)
        v2=-v2;  v3=-v3;
    end
    if(abs(x2-x4)<0.1||abs(y4-y2)<0.1)
        v2=-v2;  v4=-v4;
    end
    if(abs(x4-x3)<0.1||abs(y3-y4)<0.1)
        v4=-v4;  v3=-v3;
    end

    x1=x1+v1*-sind(angle1);
    y1=y1+v1*cosd(angle1);
    x2=x2+v2*-sind(angle2);
    y2=y2+v2*cosd(angle2);
    x3=x3+v3*-sind(angle3);
    y3=y3+v3*cosd(angle3);
    x4=x4+v4*-sind(angle4);
    y4=y4+v4*cosd(angle4);

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

    offset=[1+x1,1+y1,0; 2+x2,2+y2,0 ;2+x3,1+y3,0;3+x4,2.5+x4,0];

    R1 = [cosd(angle1) -sind(angle1) 0;sind(angle1) cosd(angle1) 0;0 0 1];
    R2 = [cosd(angle2) -sind(angle2) 0;sind(angle2) cosd(angle2) 0;0 0 1];
    R3 = [cosd(angle3) -sind(angle3) 0;sind(angle3) cosd(angle3) 0;0 0 1];
    R4 = [cosd(angle4) -sind(angle4) 0;sind(angle4) cosd(angle4) 0;0 0 1];

    vertices1=vertices+offset(1,:);
    vertices2=vertices+offset(2,:);
    vertices3=vertices+offset(3,:);
    vertices4=vertices+offset(4,:);

    ruedas_vertices1 = [vertices1(1, :)+[0 0.1 0.05]; vertices1(2, :)+[0 0.1 0.05]];
    ruedas_vertices2 = [vertices2(1, :)+[0 0.1 0.05]; vertices2(2, :)+[0 0.1 0.05]];
    ruedas_vertices3 = [vertices3(1, :)+[0 0.1 0.05]; vertices3(2, :)+[0 0.1 0.05]];
    ruedas_vertices4 = [vertices4(1, :)+[0 0.1 0.05]; vertices4(2, :)+[0 0.1 0.05]];


    % Dibuja el cubo usando plot3

    vertices1 = (R1 * (vertices1-offset(1,:)-[0.1 0.1 0])')'+offset(1,:)+[0.1 0.1 0];
    vertices2 = (R2 * (vertices2-offset(2,:)-[0.1 0.1 0])')'+offset(2,:)+[0.1 0.1 0];
    vertices3 = (R3 * (vertices3-offset(3,:)-[0.1 0.1 0])')'+offset(3,:)+[0.1 0.1 0];
    vertices4 = (R4 * (vertices4-offset(4,:)-[0.1 0.1 0])')'+offset(4,:)+[0.1 0.1 0];


    hold on;


    % Dibujar las ruedas en dos esquinas de la base inferior del cubo
    radio_rueda = 0.05;  % Radio de la rueda
    n_puntos = 50;  % Número de puntos para dibujar el círculo




    for r=1:4
        switch r
            case 1
                ruedas_vertices=ruedas_vertices1;
                R=R1;
            case 2
                ruedas_vertices=ruedas_vertices2;
                R=R2;
            case 3
                ruedas_vertices=ruedas_vertices3;
                R=R3;
            case 4
                ruedas_vertices=ruedas_vertices4;
                R=R4;
        end

        for j = 1:2
            % Genera el círculo para la rueda en el plano xy
            theta = linspace(0, 2*pi, n_puntos);
            y_rueda = radio_rueda * cos(theta) + ruedas_vertices(j, 2);
            z_rueda = radio_rueda * sin(theta) + ruedas_vertices(j, 3);
            x_rueda = ones(1, n_puntos) * ruedas_vertices(j, 1);  % Altura en Z

            coords_base = [x_rueda; y_rueda; z_rueda]- offset(r,:)' - [0.1 0.1 0]';  % Coordenadas del círculo original
            coords_rotadas = R* coords_base+ offset(r,:)' + [0.1 0.1 0]';  % Aplicar rotación

            % Extraer las coordenadas rotadas
            x_rotado = coords_rotadas(1, :);
            y_rotado = coords_rotadas(2, :);
            z_rotado = coords_rotadas(3, :);

            switch r
                case 1
                    if(j==1)
                        ruedas11(:,1:3) = [x_rotado; y_rotado; z_rotado]';
                    else
                        ruedas12(:,1:3) = [x_rotado; y_rotado; z_rotado]';
                    end
                case 2
                    if(j==1)
                        ruedas21(:,1:3) = [x_rotado; y_rotado; z_rotado]';
                    else
                        ruedas22(:,1:3) = [x_rotado; y_rotado; z_rotado]';
                    end
                case 3
                    if(j==1)
                        ruedas31(:,1:3) = [x_rotado; y_rotado; z_rotado]';
                    else
                        ruedas32(:,1:3) = [x_rotado; y_rotado; z_rotado]';
                    end
                case 4
                    if(j==1)
                        ruedas41(:,1:3) = [x_rotado; y_rotado; z_rotado]';
                    else
                        ruedas42(:,1:3) =[x_rotado; y_rotado; z_rotado]';
                    end
            end
        end
    end

    calculate_cube_projection_matrix
    calculate_wheels_projection_matrix
    top_down_view
    pause(0.1)
end
