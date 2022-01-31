function [thYaxis, skYaxis] = ap_cal(angT, rotAlign)
mean_th =  mean(angT,2);
norm_th =  norm(mean_th);
thYaxis = mean_th / norm_th;
skYaxis = inv(rotAlign) * thYaxis;