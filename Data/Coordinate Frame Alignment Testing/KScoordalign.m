%Output is a rotation matrix relating the thigh and shank IMU

function [rotAlignment] = coordAlign(Sk, Th)
%find mimimum # of datapoints between thigh and shank IMU
datapts = min(size(Th,1), size(Sk,1));

%trim ang vel data to minimum # of datapts btwn the two IMUs
Sk = Sk(1:datapts,:);
Th = Th(1:datapts,:);

%transpose vectors to get appropriate dimensions
shankangvel = Sk';
thighangvel = Th';

%calculate the thRsk - rot mtrx relating shank and thigh IMU positions
rotAlignment = thighangvel/shankangvel;