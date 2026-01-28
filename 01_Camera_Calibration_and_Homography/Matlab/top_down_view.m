

plot(mp4(1,:),mp4(2,:)); hold on;



for j=1:6
plot(mpcc1(2*j-1,:),mpcc1(2*j,:),'Color','b', 'LineWidth',2);
plot(mpcc2(2*j-1,:),mpcc2(2*j,:),'Color','r', 'LineWidth',2);
plot(mpcc3(2*j-1,:),mpcc3(2*j,:),'Color','y', 'LineWidth',2);
plot(mpcc4(2*j-1,:),mpcc4(2*j,:),'Color','g', 'LineWidth',2);
end

for p=1:50
plot(mruedas11(p,1),mruedas11(p,2),'ok', 'MarkerSize', 4, 'MarkerFaceColor','k');
plot(mruedas12(p,1),mruedas12(p,2),'ok', 'MarkerSize', 4, 'MarkerFaceColor','k');
plot(mruedas21(p,1),mruedas21(p,2),'ok', 'MarkerSize', 4, 'MarkerFaceColor','k');
plot(mruedas22(p,1),mruedas22(p,2),'ok', 'MarkerSize', 4, 'MarkerFaceColor','k');
plot(mruedas31(p,1),mruedas31(p,2),'ok', 'MarkerSize', 4, 'MarkerFaceColor','k');
plot(mruedas32(p,1),mruedas32(p,2),'ok', 'MarkerSize', 4, 'MarkerFaceColor','k');
plot(mruedas41(p,1),mruedas41(p,2),'ok', 'MarkerSize', 4, 'MarkerFaceColor','k');
plot(mruedas42(p,1),mruedas42(p,2),'ok', 'MarkerSize', 4, 'MarkerFaceColor','k');
end

% Dibujamos marco exterior a la imagen, atendiendo a que el rango va de columnas es [1..N] y de filas [1..M]:
plot([0,0,N+1,N+1,0],[0,M+1,M+1,0,0],'Color','k', 'LineWidth',2);
hold off;

set(gca,'YDir', 'reverse');