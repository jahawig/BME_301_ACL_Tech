%% Import calibration and data trials

% quaterniondataRightThigh = tree.segmentData(16).orientation;
% quaterniondataRighShank = tree.segmentData(17).orientation;
% 
% writematrix(quaterniondataRightThigh,'quatWalkingTh.csv')
% writematrix(quaterniondataRighShank,'quatWalkingSk.csv')

% angVelRightThighAP = tree2.segmentData(16).angularVelocity;
% angVelRighShankAP = tree2.segmentData(17).angularVelocity;
% 
% writematrix(angVelRightThighAP,'apTh.csv')
% writematrix(angVelRighShankAP,'apSk.csv')
% 
% angVelRightThighML = tree3.segmentData(16).angularVelocity;
% angVelRighShankML = tree3.segmentData(17).angularVelocity;
% 
% writematrix(angVelRightThighML,'mlTh.csv')
% writematrix(angVelRighShankML,'mlSk.csv')
% 
% angVelRightThighcoord = tree4.segmentData(16).angularVelocity;
% angVelRighShankcoord = tree4.segmentData(17).angularVelocity;
% 
% writematrix(angVelRightThighcoord,'coordTh.csv')
% writematrix(angVelRighShankcoord,'coordSk.csv')

clear all; close all;

%clearvars -except s_func th_func s_static th_static %if running 2+ trials

%Naming convention:
    %s_func_ml - hip f/e task
    %th_func_ml - hip f/e task
    %s_func_ap - static posture
    %th_func_ap - static posture
    %th_coord_align - circular movement 
    %sk_coord_align - circular movement 
    %s_trialData
    %th_trialData
    
s_func_ap = readtable(uigetfile('*.csv', 'Select Shank Functional aB/aD Calibration File'));
th_func_ap = readtable(uigetfile('*.csv', 'Select Thigh Functional aB/aD Calibration File'));
s_func_ml = readtable(uigetfile('*.csv', 'Select Shank Functional flex/ext Calibration File'));
th_func_ml = readtable(uigetfile('*.csv', 'Select Thigh Functional flex/ext Calibration File'));
s_trialData = readtable(uigetfile('*.csv', 'Select Shank Trial Data'));
th_trialData = readtable(uigetfile('*.csv', 'Select Thigh Trial Data'));
sk_coord_align = readtable(uigetfile('*.csv', 'Select Thigh Coordinate Frame Alignmment Calibration Data'));
th_coord_align = readtable(uigetfile('*.csv', 'Select Shank Coordinate Frame Alignmment Calibration Data'));

%% Coordinate Frame Alignment 

sk_coord = table2array(sk_coord_align(:,1:3)); %xyz 
th_coord = table2array(th_coord_align(:,1:3)); 

% call coordAlign
[rotAlignment] = coordAlign(th_coord, sk_coord);

%% medial lateral axis of roation (x axis) from flexion/extension ang vel data

skFuncMl = table2array(s_func_ml(:,1:3)); %xyz % change 6 and 8 to coorespond to data 
thFuncMl = table2array(th_func_ml(:,1:3)); % change 6 and 8 to coorespond to data 
skFuncMl = skFuncMl';
thFuncMl = thFuncMl';

% call ml_cal
[thXaxis, skXaxis] = ml_cal(thFuncMl, skFuncMl, rotAlignment);

%% anterior posterior axis of rotation (y axis) from aB/aD ang vel data

skFuncAP = table2array(s_func_ap(:,1:3)); %xyz % change 6 and 8 to coorespond to data 
thFuncAP = table2array(th_func_ap(:,1:3)); % change 6 and 8 to coorespond to data 

skFuncAP = skFuncAP';
thFuncAP = thFuncAP';

% call ap_cal
[thYaxis, skYaxis] = ap_cal(thFuncAP, rotAlignment);

%% Determine x,y,and z axis 

thZaxis = cross(thXaxis,thYaxis);
skZaxis = cross(skXaxis,skYaxis);

%Calculate X vector (corrects sagittal plane axis & ensures orthogonal) 
thXaxis = cross(thZaxis,thYaxis);
shXaxis = cross(skZaxis,skYaxis);

%% anatomical rotation matrices 
skRa = [skXaxis skYaxis skZaxis]';
thRa = [thXaxis thYaxis thZaxis]';

%% convert quaternions from trial data to rotation matrices 

%import quaternion data
trialSk = table2array(s_trialData(:,1:4));
trialTh = table2array(th_trialData(:,1:4));

%rotation matrices 
Rsk = quat2rotm(trialSk);
Rth = quat2rotm(trialTh);

%% atRas
 %Find min # of data points
datapts = min(size(s_trialData,1), size(th_trialData,1));

for i = 1:datapts
atRas(:,:,i) = Rsk(:,:,i) * skRa * inv(Rth(:,:,i) * thRa);
end


%% Calculate joint angles
for i = 1:datapts
    theta2(i) = rad2deg(asin(atRas(3,1,i)));
    theta1(i) = rad2deg(acos(atRas(3,3,i) / cosd(theta2(i))));
    theta3(i) = rad2deg(acos(atRas(1,1,i) / cosd(theta2(i))));
end

%Calibrate to initial neutral knee angle
theta2 = theta2 - theta2(1);
theta1 = theta1 - theta1(1);
theta3 = theta3 - theta3(1);

time = table2array(s_trialData(:,1));
title_name = input('What type of motion was this? ', 's');

figure(1)
hold on
plot(time(1:datapts), theta1, 'r')
plot(time(1:datapts), theta2, 'g')
plot(time(1:datapts), theta3, 'b')
xlabel('Time (ms)')
ylabel('Joint Angle (deg)')
title(title_name)
hold off



%% rot2eul
xyzeulang = rotm2eul(atRas);
% eatRas = eul2rotm(xyzeulang);
% for i = 1:datapts
%     theta2e(i) = rad2deg(asin(eatRas(3,1,i)));
%     theta1e(i) = rad2deg(acos(eatRas(3,3,i) / cosd(theta2e(i))));
%     theta3e(i) = rad2deg(acos(eatRas(1,1,i) / cosd(theta2e(i))));
% end
% 
% figure(2)
% hold on
% plot(time(1:datapts), theta1e, 'r')
% plot(time(1:datapts), theta2e, 'g')
% plot(time(1:datapts), theta3e, 'b')
% xlabel('Time (ms)')
% ylabel('Joint Angle (deg)')
% title(title_name)
% hold off
figure(2)
hold on
plot(xyzeulang(:,1));
plot(xyzeulang(:,2));
plot(xyzeulang(:,3));
