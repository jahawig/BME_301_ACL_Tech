Shank_seated = readtable("Shank_seated.csv");
Thigh_seated = readtable("Thigh_seated.csv");

shankx = table2array(Shank_seated(:,3));
shanky = table2array(Shank_seated(:,4));
shankz = table2array(Shank_seated(:,5));

thighx = table2array(Thigh_seated(:,3));
thighy = table2array(Thigh_seated(:,4));
thighz = table2array(Thigh_seated(:,5));

% shankx2 = table2array(Shankgait(:,3));
% shanky2 = table2array(Shankgait(:,4));
% shankz2 = table2array(Shankgait(:,5));
% 
% thighx2 = table2array(Thighgait(:,3));
% thighy2 = table2array(Thighgait(:,4));
% thighz2 = table2array(Thighgait(:,5));

shankRot = [];
for i = 1:920
[rotM] = rotMatrix(shankx(i,:), shanky(i,:), shankz(i,:));
shankRot(:,:,i) = [rotM];
[rotM] = rotMatrix(thighx(i,:), thighy(i,:), thighz(i,:));
thighRot(:,:,i) = [rotM];
tTs(:,:,i) = thighRot(:,:,i) * inv(shankRot(:,:,i));

angle(i,1:3) = (180/pi) * body312ang(tTs(:,:,i));
end

% shankRot = [];
% for i = 1:864
% [rotM] = rotMatrix(shankx2(i,:), shanky2(i,:), shankz2(i,:));
% shankRot2(:,:,i) = [rotM];
% [rotM] = rotMatrix(thighx2(i,:), thighy2(i,:), thighz2(i,:));
% thighRot2(:,:,i) = [rotM];
% tTs2(:,:,i) = thighRot2(:,:,i) * inv(shankRot2(:,:,i));
% 
% angle2(i,1:3) = (180/pi) * body312ang(tTs2(:,:,i));
% end

subplot(1,1,1)
hold on
plot(angle(:,1),'r');
plot(angle(:,2),'g');
plot(angle(:,3),'b');
hold off
% subplot(2,1,2)
% hold on
% plot(angle2(:,1));
% plot(angle2(:,2));
% plot(angle2(:,3));
% hold off


