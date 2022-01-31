%% Import data
s_static = readtable(uigetfile('*.csv', 'Select Shank Static Calibration File'));
th_static = readtable(uigetfile('*.csv', 'Select Thigh Static Calibration File'));
s_func = readtable(uigetfile('*.csv', 'Select Shank Functional Calibration File'));
th_func = readtable(uigetfile('*.csv', 'Select Thigh Functional Calibration File'));

s_trialData = readtable(uigetfile('*.csv', 'Select Shank Trial Data'));
th_trialData = readtable(uigetfile('*.csv', 'Select Thigh Trial Data'));

%% Coordinate Frame Alignment

%% Anatomical Calibration
s_static = table2array(s_static(:,6:8)); %pull accel data
th_static = table2array(th_static(:,6:8));

s_func =  table2array(s_func(:,9:11)); %pull gyro data
th_func =  table2array(th_func(:,9:11)); 

s_sRa = anatcal_pca(s_static,s_func);
th_sRa = anatcal_pca(th_static,th_func);

%% Convert quaternion trial data to rotm
Rs_shank = eul2rotm(deg2rad(table2array(s_trialData(:,3:5))));
Rs_thigh = eul2rotm(deg2rad(table2array(th_trialData(:,3:5))));

%% Get segment orientation
datapts = min(size(s_trialData,1), size(th_trialData,1)); %min # of datapts
Risb = [0 -1 0; 1 0 0; 0 0 1]; %conversion to ISB standards

for i = 1:datapts
    gRshank(:,:,i) = s_sRa * inv(Rs_shank(:,:,i) * Risb);
    gRthigh(:,:,i) = th_sRa * inv(Rs_thigh(:,:,i) * Risb);
    gRknee(:,:,i) = gRthigh(:,:,i) * gRshank(:,:,i)';
    
    theta2(i) = rad2deg(asin(gRknee(3,1,i)));
    theta1(i) = rad2deg(acos(gRknee(3,3,i) / cosd(theta2(i))));
    theta3(i) = rad2deg(acos(gRknee(1,1,i) / cosd(theta2(i))));
end

    %Calibrate to initial neutral knee angle
% theta2 = theta2 - theta2(1);
% theta1 = theta1 - theta1(1);
% theta3 = theta3 - theta3(1);

%% Plot results
time = table2array(s_trialData(:,1));
title_name = input('What type of motion was this? ', 's');

figure(1)
hold on
plot(time(1:datapts), theta1, 'r')
plot(time(1:datapts), theta2, 'b')
plot(time(1:datapts), theta3, 'g')
xlabel('Time (ms)')
ylabel('Joint Angle (deg)')
title(title_name)
legend('Theta 1', 'Theta 2', 'Theta 3')
hold off