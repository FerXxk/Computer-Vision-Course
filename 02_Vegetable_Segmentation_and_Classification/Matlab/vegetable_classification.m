% Usar ruta relativa al script para mayor robustez
scriptDir = fileparts(mfilename('fullpath'));
imagePath = fullfile(scriptDir, '..', 'repository', 'vegetables_1.jpg'); % Elegir cualquier imagen de la carpeta repository
imagen = imread(imagePath);

%%imagen = imresize(imagen, 7);



figure(1);
imshow(imagen); hold on;
title('Vegetable filtering');
for fruta=0:1:6
    % fruta=2; % kiwi,pim,tom,ber,lim,man,zan
    imagensegmentada=create_mask(imagen,fruta);
    % figure();
    % imshow(imagensegmentada);
    f = rgb2gray(imagensegmentada);
    T = adaptthresh (f,0.58,'ForegroundPolarity','dark');
    fbin = imbinarize (f, T);


    mask = strel('disk',9);


    fOpen  = imopen(fbin,mask);


    switch fruta
        case 0
            limexup=0.8;
            limexdo=0;
            minArea = 9000; % Área mínima
            maxArea = 10000000; % Área máxima
        case 1
            limexup=1;
            limexdo=0.7;
            minArea = 10000; % Área mínima
            maxArea = 200000; % Área máxima
        case 2
            limexup=0.9;
            limexdo=0;
            minArea = 4000; % Área mínima
            maxArea = 10000000; % Área máxima
        case 3
            limexup=0.95;
            limexdo=0.8;
            minArea = 14000; % Área mínima
        case 4
            limexup=1;
            limexdo=0.7;
            minArea = 80000; % Área mínima
            maxArea = 1000000; % Área máxima
        case 5
            limexup=0.8;
            limexdo=0;
            minArea = 9000; % Área mínima
            maxArea = 10000000; % Área máxima
        case 6
            limexdo=0.94;
            limexup=1;
            minArea = 9000; % Área mínima
            maxArea = 10000000; % Área máxima
    end

    % Etiquetar las regiones conectadas
    [L, num] = bwlabel(fOpen);

    % Obtener propiedades de las regiones
    stats = regionprops(L, 'Area', 'BoundingBox','Centroid','Eccentricity'); % Incluye BoundingBox y Área

    % Definir criterios de selección (por ejemplo, área mínima y máxima)

    % Crear una figura para mostrar las BoundingBox

    boxk=[];

    % Filtrar las regiones por área y dibujar sus BoundingBox
    for k = 1:length(stats)
        area = stats(k).Area;
        bbox = stats(k).BoundingBox;
        width = bbox(3);
        height = bbox(4);
        centroid = stats(k).Centroid; % Centroide
        excentricidad=stats(k).Eccentricity;

        % Filtrar por área y dimensiones
        if area >= minArea && area <= maxArea && excentricidad >= limexdo && excentricidad<=limexup
            boxk=[boxk,k];
        end
    end
    etiqueta={'Kiwi','Pepper','Tomato','Eggplant','Lemon','Mandarin','Carrot'};
    colores={[0.65, 0.16, 0.16],[0, 0.79, 0],'red', [0.54, 0.2, 0.39],'yellow',[1, 0.65, 0], [1, 0.55, 0]};

    for k = 1:size(boxk,2)
        % Dibujar la bounding box
        bbox = stats(boxk(k)).BoundingBox;
        centroid = stats(boxk(k)).Centroid;
        rectangle('Position', bbox, 'EdgeColor', colores{fruta+1}, 'LineWidth', 2);
        plot(centroid(1), centroid(2), '+','Color', colores{fruta+1}, 'MarkerSize', 10, 'LineWidth', 2);
        % Agregar la etiqueta
        % La posición de la etiqueta es ligeramente desplazada de la esquina superior izquierda de la bounding box
        text( bbox(1)-20 ,  bbox(2) - 40, etiqueta{fruta+1}, ...
            'Color', colores{fruta+1}, 'FontSize', 12, 'FontWeight', 'bold');
    end
end
