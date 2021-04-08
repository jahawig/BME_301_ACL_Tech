The four folders have the shank and thigh IMU data from each test we did (countermovement jump, walking, seated flexion/extension, valgus/rotation movements). 

For the valgus_rotation_movements, we just had the subject stand straight and try to do some knee valgus and rotation movements without flexing the knee too
much to see if we could get some good valgus data.

For the code, body312ang.m is the function from our BME415 class that converts the rotation matrix to angles. rotMatrix.m is the rotation matrix we generated 
at our last team meeting, and valgusanglecode.m is the code that Kate made for analyzing the data. 

Lastly, Kristen and I were still seeing some weird stuff on the graphs for the valgus/rotation angles, so we were looking at the rotation matrix we are using 
and making sure we do the correct order of rotations. We were thinking that could maybe be a source of error.
