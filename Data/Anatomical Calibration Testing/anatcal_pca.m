%INPUT - data from static and functional trial
%OUTPUT - rotation matrix relating sensor to anatomical

function sRa = anatcal_pca(static,func)

offset20 = round(0.2*length(static)); %only pull middle 60% of trial

%Calculate sup/inf axis using accel data from static trial
avgStatic = mean(static(offset20:length(static)-offset20,:)); %pull middle 60% & average
Y = avgStatic / norm(avgStatic); %norm to find inf/sup axis

%Calculate sagittal plane axis using gryo data from func trial 
func = func(offset20:length(func)-offset20,:); %pull middle 60%
coeff = pca(func);
H = coeff(:,1) / norm(coeff(:,1)); %norm sagittal axis

%Compute rotation matrix
Z = cross(H,Y); %perp to H and Y
X = cross(Z,H);
sRa = [(X/norm(X)); (Y/norm(Y)); (Z/norm(Z))];
end


%%Questions
%Which direction does each axis face?
%Are the cross products right?
%Which order do I put them in the rotation matrix

%%Notes
%MATLAB doc says PCA is in descending order of variance