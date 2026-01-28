function RedrawFrame (handleFrame, T, width, long)
%
% Función para redibujar en otra posición un sistema de coordenadas que ya se dibujó inicialmente con 'DrawFrame()'.
%
% Parámetros de entrada:
%    handleFrame: Vector con los tres objetos de tipo linea que me permite dibujar cada
%                 una de las rectas que componen el sist. coordenadas.
%    T..........: Matriz de transformación homogénea que establece la configuración del frame.
%    width......: Anchura de las líneas a dibujar.
%    long.......: Longitud de las líneas a dibujar.
%

orig = T (1:3,4);

if (nargin<4) 
   long = 1;
end   

dest1 = orig + T(1:3,1)*long;
dest2 = orig + T(1:3,2)*long;
dest3 = orig + T(1:3,3)*long;

set (handleFrame(1), 'XData',[orig(1),dest1(1)]', 'YData',[orig(2),dest1(2)]', 'ZData',[orig(3),dest1(3)]', 'Color','g', 'LineWidth', width);
set (handleFrame(2), 'XData',[orig(1),dest2(1)]', 'YData',[orig(2),dest2(2)]', 'ZData',[orig(3),dest2(3)]', 'Color','b', 'LineWidth', width);
set (handleFrame(3), 'XData',[orig(1),dest3(1)]', 'YData',[orig(2),dest3(2)]', 'ZData',[orig(3),dest3(3)]', 'Color','r', 'LineWidth', width);
