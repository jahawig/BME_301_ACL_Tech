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

s_static(:,1) = s_static(:,1) + 9.81; %adding gravity
th_static(:,1) = th_static(:,1) + 9.81;

s_func =  table2array(s_func(:,9:11)); %pull gyro data
th_func =  table2array(th_func(:,9:11)); 

s_sRa = anatcal_pca(s_static,s_func);
th_sRa = anatcal_pca(th_static,th_func);

%% Convert quaternion trial data to rotm
Rs_shank = quat2rotm(table2array(s_trialData(:,3:6))); %wxyz
Rs_thigh = quat2rotm(table2array(th_trialData(:,3:6)));

%% Get segment orientation
datapts = min(size(s_trialData,1), size(th_trialData,1)); %min # of datapts

for i = 1:datapts
    gRshank(:,:,i) = s_sRa * Rs_shank(:,:,i)';
    gRthigh(:,:,i) = th_sRa * Rs_thigh(:,:,i)';
    gRknee(:,:,i) = gRthigh(:,:,i) * gRshank(:,:,i)';
    
    kneeang(i,:) = rad2deg(rotm2eul(gRknee(:,:,i),'XYZ'));
end

    %Calibrate to initial neutral knee angle
kneeang = kneeang - kneeang(1,:);

%% Plot results
time = table2array(s_trialData(:,1)) * 1/60; %s 

figure(1)
hold on
plot(time(1:datapts),kneeang(:,1))
plot(time(1:datapts),kneeang(:,2))
plot(time(1:datapts),kneeang(:,3))
xlabel('Time (s)')
ylabel('Joint Angle (deg)')
title('Knee Angle')
legend('Theta 1', 'Theta 2', 'Theta 3')
hold off

%% Questions

%%Questions for Vitali
%how to do coordinate frame alignment
%how to not use magnetometer
%using PCA to find sagittal axis
%why would hip & knee ROM for anatomical calibration look so much diff?

%%Questions for XSens
%acceleration/gravity and angular velocity data collection
%time vector

%%Questions for Dr. Adamczyk
%cross products finding anatomical axis
%conversion of quaternion to rotm
%Risb rotm
%rotm2eul sequence
%initial calibration angle
%which angle should be which
