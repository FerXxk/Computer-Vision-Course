% Usar ruta relativa al script para mayor robustez
scriptDir = fileparts(mfilename('fullpath'));

[trainImags, trainLabels] = read_mnist(fullfile(scriptDir, '..', 'repository', 'MNIST', 'train-images-idx3-ubyte'), fullfile(scriptDir, '..', 'repository', 'MNIST', 'train-labels-idx1-ubyte'), 60000, 0);
[testImags, testLabels] = read_mnist(fullfile(scriptDir, '..', 'repository', 'MNIST', 't10k-images-idx3-ubyte'), fullfile(scriptDir, '..', 'repository', 'MNIST', 't10k-labels-idx1-ubyte'), 10000, 0);

%% Procesar imágenes y etiquetas
vector_caracteristicas = [];
Z = cell(10, 1);

for i = 1:60000
    Imag = trainImags(:, :, i);
    label = trainLabels(i);
    vector_caracteristicas(:, i) = Imag(:);

    % Almacenar vectores columna según la clase
    Z{label + 1} = [Z{label + 1}, vector_caracteristicas(:, i)];
end

% Número de muestras por clase
Nprot = cellfun(@(x) size(x, 2), Z);

%% Calcular medias y matrices de dispersión
D = size(vector_caracteristicas, 1);
mu_clases = cellfun(@(z) mean(z, 2), Z, 'UniformOutput', false);
mu_total = mean(vector_caracteristicas, 2);

Sb = zeros(D, D); % Matriz de dispersión entre clases
Sw = zeros(D, D); % Matriz de dispersión dentro de clases

for nclase = 1:10
    mu = mu_clases{nclase};
    z_centrado = Z{nclase} - mu;
    Sw = Sw + (z_centrado * z_centrado');
    Sb = Sb + Nprot(nclase) * (mu - mu_total) * (mu - mu_total)';
end

%% Resolver el problema de valores propios

% Ordenamos y elegimos los primeros NA autovalores
NA= 200;
[V, D] = eig(Sb, Sw);
[~, idx] = sort(diag(D), 'descend');
V = V(:, idx);

W = V(:, 1:NA);

trainProjected = W' * vector_caracteristicas;
testProjected = reshape(testImags, [], size(testImags, 3));
testProjected = W' * testProjected;

%% Clasificación bayesiana en el espacio reducido
VX = zeros(NA, NA, 10);
Vinv = zeros(NA, NA, 10);
f = zeros(10, 1);

lambda = 0.01;
for number = 0:9
    nclase = number + 1;
    mu = mean(trainProjected(:, trainLabels == number), 2);
    z_centrado = trainProjected(:, trainLabels == number) - mu;
    V = (z_centrado * z_centrado') / Nprot(nclase);
    V = V + lambda * eye(size(V));

    VX(:, :, nclase) = V;
    Vinv(:, :, nclase) = inv(V);
    detV = det(V);
    if detV <= 0
        detV = eps; % Evitar log(0)
    end
    f(nclase) = log(0.1) - 0.5 * log(detV);
end

mu_classes_reduced = cellfun(@(z) W' * z, mu_clases, 'UniformOutput', false);

%% Clasificación con el test
fallos = 0;
Ntest = 10000;


for i = 1:Ntest
    x = testProjected(:, i); % Vector de características proyectado
    label = testLabels(i);

    fdMax = -Inf;
    clase = -1;

    for number = 0:9
        nclase = number + 1;
        mu = mu_classes_reduced{nclase};
        Vinv_class = Vinv(:, :, nclase);

        rCuad = (x - mu)' * Vinv_class * (x - mu);
        fd = -0.5 * rCuad + f(nclase);

        if fd > fdMax
            fdMax = fd;
            clase = number;
        end
    end

    if clase ~= label
        fallos = fallos + 1;
    end
end

acc = (Ntest - fallos) / Ntest * 100;
disp(['Test number: ', num2str(Ntest), ', Failures: ', num2str(fallos), ', Accuracy: ', num2str(acc), '%']);





%% Clasificacion con el train

fallos1 = 0;
Ntrain = 60000;

for i = 1:Ntrain
    x = trainProjected(:, i); % Vector de características proyectado
    label = trainLabels(i);

    fdMax = -Inf;
    clase = -1;

    for number = 0:9
        nclase = number + 1;
        mu = mu_classes_reduced{nclase};
        Vinv_class = Vinv(:, :, nclase);

        rCuad = (x - mu)' * Vinv_class * (x - mu);
        fd = -0.5 * rCuad + f(nclase);

        if fd > fdMax
            fdMax = fd;
            clase = number;
        end
    end

    if clase ~= label
        fallos1 = fallos1 + 1;
    end
end

acc1 = (Ntrain - fallos1) / Ntrain * 100;
disp(['Train number: ', num2str(Ntrain), ', Failures: ', num2str(fallos1), ', Accuracy: ', num2str(acc1), '%']);
disp(['Success rate: [train, test] = [', num2str(acc1), '% ,', num2str(acc), '%] ']);
