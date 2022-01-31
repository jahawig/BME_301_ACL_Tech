%% Load data
% Change the filename here to the name of the file you would like to import
tree1= load_mvnx('walk_mvn_quat.mvnx');

%% Read some basic data from the file
mvnxVersion = tree1.metaData.mvnx_version; % version of the MVN Studio used during recording

if (isfield(tree1.metaData, 'comment'))
    fileComments = tree1.metaData.comment; % comments written when saving the file
end

%% Read some basic properties of the subject;
frameRate = tree1.metaData.subject_frameRate;
suitLabel = tree1.metaData.subject_label;
originalFilename = tree1.metaData.subject_originalFilename;
recDate = tree1.metaData.subject_recDate;
segmentCount = tree1.metaData.subject_segmentCount;

%% Retrieve sensor labels
%creates a struct with sensor data
if isfield(tree1,'sensorData') && isstruct(tree1.sensorData)
    sensorData = tree1.sensorData;
end

%% Retrieve segment labels
%creates a struct with segment definitions
if isfield(tree1,'segmentData') && isstruct(tree1.segmentData)
    segmentData = tree1.segmentData;
end

%% Read the data from the structure e.g. segment 1
if isfield(tree1.segmentData,'position')
    % Plot position of segment 1
    figure('name','Position of first segment')
    plot(tree1.segmentData(1).position)
    xlabel('frames')
    ylabel('Position in the global frame')
    legend('x','y','z')
    title ('Position of first segment')
    
    % Plot 3D displacement of segment 1
    figure('name','Position of first segment in 3D')
    plot3(tree1.segmentData(1).position(:,1),tree1.segmentData(1).position(:,2),tree1.segmentData(1).position(:,3));
    xlabel('x')
    ylabel('y')
    zlabel('z')
    title ('Displacement of first segment in space')
end
