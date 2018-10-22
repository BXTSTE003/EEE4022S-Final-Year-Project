 function vidCell = ReadFlowData(filename)
% ReadFlowData(filename) reads the optical flow data from a video file
% frame by frame, downsamples the frames to make them smaller and then
% outputs a data array with frames as the columns of the array and the x
% and y velocities for each pixel as the rows of the array.
    
    % Create a video reader object to access the file and reset it.
    reader = vision.VideoFileReader(filename);
    reset(reader);
    
    % Create an optical flow object to record the apparent motion of the
    % pixels - uses the previous frame to calculate.
    optical = opticalFlowHS;
    
    % Downsample dimensions.
    r = 1:8:360; %height
    c = 1:8:640; %width
    sizeV = 3600;
    
    % Initialise the data variable.
    vidCell = {};
        
    % Loop through the video.
    while ~isDone(reader)
        % Get a new frame of video and convert from RGB to greyscale.
        I = reader();
        I = rgb2gray(I);
        
        % Use the grey frame estimate the optical flow data.
        Flow = estimateFlow(optical,I);
        
        % Read the velocity variables from the flow object.
        V1x = Flow.Vx; 
        V1y = Flow.Vy;

        % Downsample the velocity variables.
        VxD = V1x(r,c);
        VyD = V1y(r,c);
        
        % Reshape the velocity variables into a single column.
        VxR = double(reshape(VxD,sizeV,1));
        VyR = double(reshape(VyD,sizeV,1));
        VR = [VxR;VyR];
        
        % Append the velocity variable to the end of the array.
        vidCell{end+1} = VR;
    end
end

