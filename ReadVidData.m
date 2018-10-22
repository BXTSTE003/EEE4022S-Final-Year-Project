function vidArray = ReadVidData(filename)
% ReadVidData(filename) reads the pixel intensity data from a video file
% frame by frame, downsamples the frames to make them smaller and then
% outputs a data array with frames as columns of the array and pixels as
% rows of the array.

    % Create a video reader object to access the file and reset it.
    reader = vision.VideoFileReader(filename);
    reset(reader);
    
    % Downsample dimensions.
    r = 1:8:360; %height
    c = 1:8:640; %width
    sizeV = 3600;
    
    % Initialise the data array.
    vidArray = [];
    
    % Loop through the video.
    while ~isDone(reader)
        % Get a new frame of video and convert from RGB to greyscale.
        I = reader();
        I = rgb2gray(I);
        
        % Downsample the grey frame.
        ID = I(r,c);
        
        % Reshape the downsampled frame to a single column.
        IR = double(reshape(ID,sizeV,1));
        
        % Append this frame to the end of the data array.
        vidArray = [vidArray, IR];
    end
end

