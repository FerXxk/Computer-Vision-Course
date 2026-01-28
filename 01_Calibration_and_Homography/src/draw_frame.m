function handleFrame = DrawFrame (T, width, long)
%
% Función para dibujar un sistema de coordenadas por primera vez.
%
% Parámetros de entrada:
%    T..........: Matriz de transformación homogénea que establece la configuración del frame.
%    width......: Anchura de las líneas a dibujar.
%    long.......: Longitud de las líneas a dibujar.
% Parámetros de salida:
%    handleFrame: Vector con los tres objetos de tipo linea  que constituyen los ejes del sist. coordenadas y 
%                 que me permiterá redibujarlas más adelante en una nueva posición con 'RedrawFrame()'.
%

% Vector traslación de la matriz 'T' determina el origen del sistema de referencia:
orig = T (1:3,4);

% Los tres vectores directores del sistema de referencia se obtienen de las correspondientes columnas de 'T':
e1 = T(1:3,1);  % Eje X.
e2 = T(1:3,2);  % Eje Y.
e3 = T(1:3,3);  % Eje Z.
 
if (nargin<3) 
   long = 1;
end

lineOX = [orig, orig + e1*long]';
lineOY = [orig, orig + e2*long]';
lineOZ = [orig, orig + e3*long]';

l1 = line (lineOX(:,1),lineOX(:,2),lineOX(:,3), 'color', 'g', 'LineWidth', width);
l2 = line (lineOY(:,1),lineOY(:,2),lineOY(:,3), 'color', 'b', 'LineWidth', width);
l3 = line (lineOZ(:,1),lineOZ(:,2),lineOZ(:,3), 'color', 'r', 'LineWidth', width);
handleFrame = [l1,l2,l3];
