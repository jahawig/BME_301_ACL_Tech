function [rotAlignment] = coordAlign(Th, Sk)
shankx = Sk(:,1);
shanky = Sk(:,2);
shankz = Sk(:,3);

thighx = Th(:,1);
thighy = Th(:,2);
thighz = Th(:,3);
datapts = min(size(Th,1), size(Sk,1));
for i = 1:datapts
 shankangvel(:,i) = [shankx(i); shanky(i) ; shankz(i)]; 
 thighangvel(:,i) = [thighx(i),thighy(i),thighz(i)]; 
end 

rotAlignment = thighangvel/shankangvel;