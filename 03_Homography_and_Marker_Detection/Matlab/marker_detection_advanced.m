

for escena=1:1:4  %% Para cada escena

    switch escena
        case 1
            f = imread ("scene_photo_1.jpg");
            minArea = 14000; % Área mínima
            maxArea = 25000; % Área máxima
            minWidth = 250; % Ancho mínimo
            minHeight = 200; % Altura mínima
            m1=10; m2=3; m3=3; % Parámetros máscaras
            tipo='disk';

        case 2
            f = imread ("scene_photo_2.jpg");
            minArea = 10000; % Área mínima
            maxArea = 30000; % Área máxima
            minWidth = 300; % Ancho mínimo
            minHeight = 200; % Altura mínima
            m1=10; m2=3; m3=3; % Parámetros máscaras
            tipo='disk';
        case 3
            f = imread ("scene_photo_3.jpg");
            minArea = 14000; % Área mínima
            maxArea = 40000; % Área máxima
            minWidth = 350; % Ancho mínimo
            minHeight = 350; % Altura mínima
            m1=10; m2=3; m3=3; % Parámetros máscaras
            tipo='disk';
        case 4
            f = imread ("scene_photo_4.jpg");
            minArea = 47000; % Área mínima
            maxArea = 50000; % Área máxima
            minWidth = 350; % Ancho mínimo
            minHeight = 300; % Altura mínima
            m1=[25,25]; m2=[5,5]; m3=[10,10]; % Parámetros máscaras
            tipo='rectangle';

    end

    fgray = rgb2gray(f); % Convertir a escala de grises

    T = adaptthresh (fgray,0.58,'ForegroundPolarity','dark');

    fbin = imbinarize (fgray, T);  % Binarizamos la imagen

    % Etiquetar las regiones obtenidas
    [L, num] = bwlabel(fbin);

    % Obtener propiedades de las regiones
    stats = regionprops(L, 'Area', 'BoundingBox'); % Incluye BoundingBox y Área

    boxk=[];

    % Filtrar las regiones por área y dibujar sus BoundingBox
    for k = 1:length(stats)
        area = stats(k).Area;
        bbox = stats(k).BoundingBox;
        width = bbox(3);
        height = bbox(4);

        % Filtrar por área y dimensiones
        if area >= minArea && area <= maxArea && width >= minWidth && height >= minHeight
            boxk=[boxk,k]; % Almacenamos bounding box que cumplan esas condiciones
        end
    end



    %% Deteccion de areucos y homografia

    imagenesresultantes={};
    for k= 1:length(boxk)
        bbox = stats(boxk(k)).BoundingBox;

        % Ampliar la BoundingBox
        scaleFactor = 1.4;  % Factor de escala
        expandedBBox = bbox;
        expandedBBox(3) = bbox(3) * scaleFactor;  % Aumentar el ancho
        expandedBBox(4) = bbox(4) * scaleFactor;  % Aumentar la altura

        % Asegurarse de que la caja ampliada no se salga de los límites de la imagen
        expandedBBox(1) = max(1, bbox(1) - (expandedBBox(3) - bbox(3)) / 2);  % Ajustar x
        expandedBBox(2) = max(1, bbox(2) - (expandedBBox(4) - bbox(4)) / 2);  % Ajustar y
        expandedBBox(3) = min(size(fbin,2) - expandedBBox(1), expandedBBox(3));  % Ajustar ancho
        expandedBBox(4) = min(size(fbin,1) - expandedBBox(2), expandedBBox(4));  % Ajustar alto

        % Extraer la región de la imagen dentro de la BoundingBox ampliada
        x1 = round(expandedBBox(1)); % Esquina superior izquierda de la caja ampliada
        y1 = round(expandedBBox(2));
        x2 = round(expandedBBox(1) + expandedBBox(3) - 1); % Esquina inferior derecha de la caja ampliada
        y2 = round(expandedBBox(2) + expandedBBox(4) - 1);

        expandedRegion = fbin(y1:y2, x1:x2); % Recortamos caja ampliada de la imagen


        mask  = strel(tipo,m1);


        fOpen  = imopen(expandedRegion,mask); % Abrimos la imagen

        fWhiteTopHat = expandedRegion-fOpen; % Obtenemos el WhiteTopHat para quedarnos solo con los bordes del areuco

        mask  = strel(tipo,m2);

        fBinOpen = imopen(fWhiteTopHat,mask);  % Eliminamos puntos blancos

        fBinOpenClose = imclose(fBinOpen,mask);

        g = fBinOpenClose;

        mask  = strel(tipo,m3);

        gEro = imerode(g,mask);  % Erosionamos la imagen resultante para obtener líneas más finas

        [H,tabTheta,tabRho] = hough(gEro); % Una vez tengamos los bordes delimitados hacemos Hough


        picos = houghpeaks(H, 4,'Threshold',max(H(:))*0.3); % Nos quedamos con las 4 líneas de los bordes

        intersecciones = []; % Para almacenar los puntos de intersección

        for i = 1:4
            % Parámetros de la línea i
            r1 = tabRho(picos(i, 1));
            t1 = tabTheta(picos(i, 2));
            a1 = cosd(t1);
            b1 = sind(t1);
            c1 = -r1;

            for j = i+1:4
                % Parámetros de la línea j
                r2 = tabRho(picos(j, 1));
                t2 = tabTheta(picos(j, 2));
                a2 = cosd(t2);
                b2 = sind(t2);
                c2 = -r2;

                % Sistema lineal para encontrar el punto de intersección
                A = [a1 b1; a2 b2];
                B = [-c1; -c2];

                if det(A) ~= 0 % Si las líneas no son paralelas
                    point = A \ B; % Intersección
                    intersecciones = [intersecciones; point']; % Agrega la intersección
                end
            end
        end

        interseccionesValidas = intersecciones(all(intersecciones >= 0, 2), :); % Solo almacenamos las intersecciones positivas

        [N2,M2]=size(expandedRegion); % Calculamos tamaño de la imagen

        if N2<M2   % Cogemos el lado más grande para cuadrarla
            M2=N2;
        else
            N2=M2;
        end

        destinationPoints = [ 10, N2-10;M2-10,N2-10;10,10;M2-10,10;  ];  % Proyectamos el aruco en una imagen cuadrada de su tamaño

        H = fitgeotrans(interseccionesValidas, destinationPoints, 'projective');

        outputImage = imwarp(expandedRegion, H, 'OutputView', imref2d(size(expandedRegion))); % Homografía

        marco = [ 10, 10, N2-10 ,M2-10 ];
        img_cortada = imcrop(outputImage,marco); % Recortamos para quitar el borde blanco

        tamano_areucos = [786, 786];

        % Ampliar la imagen al tamaño de los areucos
        img_ampliada = imresize(img_cortada, tamano_areucos);

        imagenesresultantes{k}=img_ampliada; % Guardamos la imagen

    end

    %% Comparación con plantillas de areuco
    marcoar = [95,95, 785, 785];
    iguales=0;
    igualesFinal=0;
    areucobueno=0;
    probabilidades=0;

    for areucos=1:1:length(boxk)
        img_ampliada=imagenesresultantes{areucos}; % Para cada areuco detectado en la imagen
        for plantilla=0:1:3
            switch plantilla % Probamos cada plantilla
                case 0
                    a = imread ("arucoID0_marco.png");

                case 1
                    a = imread ("arucoID1_marco.png");

                case 2
                    a = imread ("arucoID2_marco.png");

                case 3
                    a = imread ("arucoID3_marco.png");

            end
            T = adaptthresh (a,0.58,'ForegroundPolarity','dark');
            abin = imbinarize (a, T);  % Binarizamos
            abin=imcrop(abin, marcoar); % Recortamos plantilla para quitar el borde blanco
            for espejo=0:1:2
                switch espejo   % Hay que tener en cuenta que la imagen este en espejo
                    case 0
                        aesp = abin;
                    case 1
                        aesp = flip(abin, 1);
                    case 2
                        aesp = flip(abin, 2);
                end
                for orientacion=0:1:4
                    switch orientacion % Y las cuatro posibles orientaciones
                        case 0
                            ar = imrotate(aesp, 90);
                        case 1
                            ar = imrotate(aesp, 180);
                        case 2
                            ar = imrotate(aesp, 270);
                        case 3
                            ar=aesp;
                    end

                    for y=1:1:750
                        for x=1:1:750
                            if ar(x, y) == img_ampliada(x, y) % Si el pixel coincide en las dos imagenes, se suma 1
                                iguales=iguales+1;
                            end
                        end
                    end
                    if iguales>igualesFinal
                        igualesFinal=iguales; % Actualizo el número de pixeles coincidentes
                        areucobueno(areucos)=plantilla; % La que más pixeles coincida es la plantilla que le corresponde


                    end
                    iguales=0; % Se reinician los pixeles iguales al cambiar de plantilla
                end

            end

        end
        % fprintf('El areuco %d coincide con la plantilla %d \n',areucos,areucobueno(areucos)) % Muestra este mensaje por cada areuco detectado en la imagen

        probabilidades(areucos)=igualesFinal/(750*750)*100; % La probabilidad se calcula dividiendo los pixeles iguales entre los pixeles totales

        igualesFinal=0; % Se reinician los pixeles iguales al cambiar de areuco
    end




    figure() % Dibujamos sobre la foto original las bounding boxes de los areucos identificados junto a el resultado determinado y su probabilidad
    imshow(f); hold on;
    for k = 1:size(boxk,2)
        % Dibujar la bounding box
        bbox = stats(boxk(k)).BoundingBox; % Para cada bounding box
        etiqueta = sprintf('Areuco %d con probabilidad %.2f%% ', areucobueno(k), probabilidades(k)); % Mensaje que se dibujara junto a la bounding box
        rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2); % Dibuja bounding box

        % Agregar la etiqueta
        % La posición de la etiqueta es ligeramente desplazada de la esquina superior izquierda de la bounding box
        text( bbox(1)-20 ,  bbox(2) - 40, etiqueta, 'Color', 'black', 'FontSize', 14, 'FontWeight', 'bold');
    end

end