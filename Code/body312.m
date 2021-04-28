function angles = body312ang(R)
% function angles = body312ang(R)
%
% Solves for successive Body Three 3-1-2 rotation angles q1, q2, q3 
% that would generate the rotation matrix R
%
% Input:	- R         Rotation matrix
% Output:	- angles    [q1, q2, q3]
%                        Note that the angles are given in the range 
%                        from -pi to +pi radians.

    if size(R)~=[3,3]; 
       disp('Error: rotation matrix has to be a 3x3 matrix')
       return;
    end;

    if sum(isnan(R(:)))~=0, angles=[NaN,NaN,NaN]; return; end

    q2 = asin(R(3,2));  %'assumption' that cos(alpha)>0

    q3sin = asin(-R(3,1)/cos(q2));
    q3cos = acos(R(3,3)/cos(q2));
    if (q3cos>pi/2 & q3sin>0); q3=pi-q3sin; end;
    if (q3cos>pi/2 & q3sin<0); q3=-pi-q3sin; end; 
    if (q3cos<=pi/2); q3=q3sin; end;

    q1sin= asin(-R(1,2)/cos(q2));
    q1cos= acos(R(2,2)/cos(q2));
    if (q1cos>pi/2 & q1sin>0); 
        q1=-pi-q1sin;  %WAS POSITIVE PI
    end;
    if (q1cos>pi/2 & q1sin<0); 
        q1=-pi-q1sin; 
    end; 
    if (q1cos<=pi/2); 
        q1=q1sin;    
    end; 


    angles=[q1 q2 q3];
end
