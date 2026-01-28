%%
figure (3); 
plot3(mp(1,:),mp(2,:),mp(3,:)) 
hold on
plot3(mp2(1,:),mp2(2,:),mp2(3,:))
hold off
% plot(mp4(1,:),mp4(2,:))
DrawFrame(eye(4),1,1)
DrawFrame(wTc,1,1)