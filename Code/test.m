%Import Data
shankData = importdata('Shank_gait.csv');
thighData = importdata('Thigh_gait.csv');

    %x = data(i,3) = rot
    %y = data(i,4) = flex
    %z = data(i,5) = val

%Pull length data and create zero arrays
numFrames = length(shankData.data);
Ts = zeros(3,3,numFrames);
Tt = zeros(3,3,numFrames);
Tf = zeros(3,3,numFrames);
angles = zeros(numFrames, 3);

%Create global to segment matrices for the thigh and shank
for i = 1:numFrames
    %Shank matrix (global to segment)
    Ts(1,1,i) = cosd(shankData.data(i,5)) * cosd(shankData.data(i,3));
    Ts(1,2,i) = (sind(shankData.data(i,4)) * sind(shankData.data(i,5)) * cosd(shankData.data(i,3))) - (cosd(shankData.data(i,4)) * sind(shankData.data(i,3)));
    Ts(1,3,i) = (cosd(shankData.data(i,4)) * sind(shankData.data(i,5)) * cosd(shankData.data(i,3))) + (sind(shankData.data(i,4)) * sind(shankData.data(i,3)));
    Ts(2,1,i) = cosd(shankData.data(i,5)) * sind(shankData.data(i,3));
    Ts(2,2,i) = (sind(shankData.data(i,4)) * sind(shankData.data(i,5)) * sind(shankData.data(i,3))) + (cosd(shankData.data(i,4)) * cosd(shankData.data(i,3)));
    Ts(2,3,i) = (cosd(shankData.data(i,4)) * sind(shankData.data(i,5)) * sind(shankData.data(i,3))) - (sind(shankData.data(i,4)) * cosd(shankData.data(i,3)));
    Ts(3,1,i) = -sind(shankData.data(i,5));
    Ts(3,2,i) = sind(shankData.data(i,4)) * cosd(shankData.data(i,5));
    Ts(3,3,i) = cosd(shankData.data(i,4)) * cosd(shankData.data(i,5));
    
    %Thigh matrix (global to local)
    Tt(1,1,i) = cosd(thighData.data(i,5)) * cosd(thighData.data(i,3));
    Tt(1,2,i) = (sind(thighData.data(i,4)) * sind(thighData.data(i,5)) * cosd(thighData.data(i,3))) - (cosd(thighData.data(i,4)) * sind(thighData.data(i,3)));
    Tt(1,3,i) = (cosd(thighData.data(i,4)) * sind(thighData.data(i,5)) * cosd(thighData.data(i,3))) + (sind(thighData.data(i,4)) * sind(thighData.data(i,3)));
    Tt(2,1,i) = cosd(thighData.data(i,5)) * sind(thighData.data(i,3));
    Tt(2,2,i) = (sind(thighData.data(i,4)) * sind(thighData.data(i,5)) * sind(thighData.data(i,3))) + (cosd(thighData.data(i,4)) * cosd(thighData.data(i,3)));
    Tt(2,3,i) = (cosd(thighData.data(i,4)) * sind(thighData.data(i,5)) * sind(thighData.data(i,3))) - (sind(thighData.data(i,4)) * cosd(thighData.data(i,3)));
    Tt(3,1,i) = -sind(thighData.data(i,5));
    Tt(3,2,i) = sind(thighData.data(i,4)) * cosd(thighData.data(i,5));
    Tt(3,3,i) = cosd(thighData.data(i,4)) * cosd(thighData.data(i,5));

    %Calculate thigh to shank rotation matrix
    Tf(:,:,i) = Tt(:,:,i) * inv(Ts(:,:,i));
    
    %Compute knee angles
    angles(i,1:3) = (180/pi) .* body312ang(Tf(:,:,i));
end

%Make a pretty plot
plot(shankData.data(:,1), angles(:,1), 'r', shankData.data(:,1), angles(:,2), 'b', shankData.data(:,1), angles(:,3), 'g')
xlabel('Index')
ylabel('Knee Angle (deg)')
legend('Flexion-Extension', 'Varus-Valgus', 'Internal-External Rotation')
