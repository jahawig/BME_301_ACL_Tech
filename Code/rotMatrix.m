function [rotM] = rotMatrix(e_x, e_y, e_z)
A = cosd(e_z)*cosd(e_y);
B = cosd(e_z)*sind(e_y)*sind(e_x) - sind(e_z)*cosd(e_x);
C = cosd(e_z)*sind(e_y)*cosd(e_x) + sind(e_z)*sind(e_x);
D = sind(e_z)*cosd(e_y);
E = sind(e_z)*sind(e_y)*sind(e_x) + cosd(e_z)*cosd(e_x);
F = sind(e_z)*sind(e_y)*cosd(e_x) - cosd(e_z)*sind(e_x);
G = -sind(e_y);
H = cosd(e_y)*sind(e_x);
I = cosd(e_y)*cosd(e_x)
rot_1 = [A B C;
         D E F;
         G H I]
 rotM = rot_1;
