

 [trainImags ,trainLabels] = readMNIST('./MNIST/train-images-idx3-ubyte','./MNIST/train-labels-idx1-ubyte', 60000, 0);
 [testImags, testLabels] = readMNIST ('./MNIST/t10k-images-idx3-ubyte', './MNIST/t10k-labels-idx1-ubyte', 10000, 0);


%% Procesar imágenes y etiquetas
vector_caracteristicas = [];
Z = cell(10, 1);

for i = 1:60000
    Imag = trainImags(:, :, i);
    label = trainLabels(i);
    vector_caracteristicas(:, i) = Imag(:); % Vector de 400x1

    % Almacenar vectores columna según la clase
    Z{label + 1} = [Z{label + 1}, vector_caracteristicas(:, i)];
end

% Número de muestras por clase
Nprot = cellfun(@(x) size(x, 2), Z);

%% Calcular medias, covarianzas y matrices inversas

VX = zeros(400, 400, 10); % Matrices de covarianza
Vinv = zeros(400, 400, 10); % Inversas de covarianza
f = zeros(10, 1); % Función de decisión 

lambda = 1e-1; 

for number = 0:9
    nclase = number + 1;
    mu = mean(Z{nclase}, 2);
    Z_centrado = Z{nclase} - mu;
    V = (Z_centrado * Z_centrado') / Nprot(nclase);
    V = V + lambda * eye(size(V));  % Regularizamos con la lambda

    VX(:, :, nclase) = V;
    Vinv(:, :, nclase) = inv(V);
    
    detV = det(V);
    if detV <= 0
        detV = eps; % Evitar log(0)
    end
    f(nclase) = log(0.1) - 0.5 * log(detV);
end

mu_clases = cell(10, 1); % Medias de las 10 clases

for number = 0:9
    mu_clases{number + 1} = mean(Z{number + 1}, 2); 
end

%% Clasificación de patrones elegidos aleatoriamente:

fallos=0;
Ntest=10000;
figure(1);
hold on;

for i = 1:Ntest
    % Obtener la imagen de prueba y su etiqueta
    Imag = testImags(:, :, i);
    label = testLabels(i); % Numero real de la imagen
    x = Imag(:); % Vector de características 

    % Inicializar variables para encontrar la clase
    fdMax = -Inf;
    clase = -1;   
    % Calcular distancias de Mahalanobis y funciones de decisión para cada clase
    for number = 0:9
        nclase = number + 1; 
        mu = mu_clases{nclase}; % Media de la clase actual
        Vinv_class = Vinv(:, :, nclase); % Inversa de la covarianza de la clase actual

        % Distancia de Mahalanobis
        rCuad = (x - mu)' * Vinv_class * (x - mu);

        % Función de decisión
        fd = -0.5 * rCuad + f(nclase);

        % Actualizar la clase si fd es mayor
        if fd > fdMax
            fdMax = fd;
            clase = number;
        end

    end

    % Dibujar el resultado con color según la clase asignada
 
 img_ampliada = imresize(Imag, 10);
 imshow(img_ampliada);
 title(['Número real: ' num2str(label)]);


% Mostrar la predicción

if(clase==label)
     text(10, 10, ['Predicción: ' num2str(clase)], 'Color', 'green', 'FontSize', 12, 'FontWeight', 'bold');
     pause(0.1);
else
    text(10, 10, ['Predicción: ' num2str(clase)], 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold');
     pause(0.3);
    fallos=fallos+1;
end

end

acc=(Ntest-fallos)/Ntest*100; % Calculamos tasa de aciertos
 disp(['Número de test: ' num2str(Ntest) ,', Fallos: ' num2str(fallos) ', Acierto: ' num2str(acc) '%' ]);
hold off;

%%
fallos=0;
Ntrain=60000;
figure(1);
hold on;

for i = 1:Ntrain
    % Obtener la imagen de prueba y su etiqueta
    Imag = trainImags(:, :, i);
    label = trainLabels(i); % Numero real de la imagen
    x = Imag(:); % Vector de características 

    % Inicializar variables para encontrar la clase
    fdMax = -Inf;
    clase = -1;   
    % Calcular distancias de Mahalanobis y funciones de decisión para cada clase
    for number = 0:9
        nclase = number + 1; 
        mu = mu_clases{nclase}; % Media de la clase actual
        Vinv_class = Vinv(:, :, nclase); % Inversa de la covarianza de la clase actual

        % Distancia de Mahalanobis
        rCuad = (x - mu)' * Vinv_class * (x - mu);

        % Función de decisión
        fd = -0.5 * rCuad + f(nclase);

        % Actualizar la clase si fd es mayor
        if fd > fdMax
            fdMax = fd;
            clase = number;
        end

    end

    % Dibujar el resultado con color según la clase asignada
 
img_ampliada = imresize(Imag, 10);
imshow(img_ampliada);
title(['Número real: ' num2str(label)]);


% Mostrar la predicción

if(clase==label)
    text(10, 10, ['Predicción: ' num2str(clase)], 'Color', 'green', 'FontSize', 12, 'FontWeight', 'bold');
    pause(0.01);
else
    text(10, 10, ['Predicción: ' num2str(clase)], 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold');
    pause;
    fallos=fallos+1;
end

end

acc=(Ntrain-fallos)/Ntrain*100; % Calculamos tasa de aciertos
 disp(['Número de train: ' num2str(Ntrain) ,', Fallos: ' num2str(fallos) ', Acierto: ' num2str(acc) '%' ]);
hold off;

