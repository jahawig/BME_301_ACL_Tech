% funtion to calculate the x axis of rotation from flexion extension data
function [thXaxis, skXaxis] = ml_cal(angT, angS, rotAlign)
% rot align is a 3x3 coordinate frame alignment matrix 
% angS is the raw angular velocity xyz output from the IMU (3xn)
% (3x3) x (3xn) = (3xn) 
% (3xn) - (3xn)
%Find min # of data points
datapts = min(size(angT,1), size(angS,1));
for i = 1:datapts  %lenth of angT
    thWkneejoint(:,i) =((rotAlign) * (angS(:,i))) - angT(:,i);
   
end

% take the mean then normalize the vector 
mean_th =  mean(thWkneejoint,2);
norm_th =  norm(mean_th);

thXaxis = mean_th / norm_th;
skXaxis = inv(rotAlign) * thXaxis;