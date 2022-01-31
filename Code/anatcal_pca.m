%INPUT - data from static and functional trial
%OUTPUT - rotation matrix relating sensor to anatomical

function sRa = anatcal_pca(static,func)

s_offset20 = round(0.2*length(static)); %only pull middle 60% of trial
f_offset20 = round(0.2*length(func));
static = static(s_offset20:length(static)-s_offset20,:);
func = func(f_offset20:length(func)-f_offset20,:);

%Calculate sup/inf axis using accel data from static trial
avgStatic = mean(static);
H = avgStatic / norm(avgStatic); %norm to find inf/sup axis

%Calculate sagittal plane axis using gryo data from func trial 
coeff = pca(func);
X = coeff(:,1) / norm(coeff(:,1)); %norm sagittal axis
X = -X; %axis needs to point laterally

%Compute rotation matrix
Y = cross(H,X); %perp to H and Y
Z = cross(X,Y);
sRa = [(X/norm(X))'; (Y/norm(Y)); (Z/norm(Z))]; %create matrix & norm
end