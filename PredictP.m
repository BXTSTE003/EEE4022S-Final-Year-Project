function [t,AnomalyArray] = PredictP(pixelnet,filename)
% PredictP(pixelnet,filename) takes in a pixel network and a test file and
% determines the location of anomalies, based on errors between the
% autoencoder's predicted output and the input.

    % obtain the pixel intensity data and calculate how many samples are in
    % the data.
    data = ReadVidData(filename);
    samples = size(data,2);
    
    % preallocate the variables for speed.
    Err = zeros(1,samples);
    MovAve = zeros(1,samples);
    AnomalyArray = zeros(1,samples);
    slidingwindow = zeros(1,12);
    
    % create an array with the time in seconds for the video.
    t = (1:samples)/25;
    
    % loop through the samples.
    for ii=1:samples
        % obtain the value of the current sample.
        currsample = data(:,ii);
        
        % predict the autoencoder's output.
        prediction = pixelnet(currsample,'UseGPU','yes');
        
        % calculate the prediction error.
        E = currsample - prediction;
        
        % determine what percentage of the predictions are outliers
        outlier = isoutlier(E,'mean');
        Err(ii) = 100*nnz(outlier)/3600;
        
        % take an 11 point moving average - adjust slightly if the current
        % index is less than 11.
        if ii < 11
            kk = 1;
            factor1 = 1/(ii);
        else
            kk = ii-10;
            factor1 = 1/11;
        end
        MovAve(ii) = factor1*sum(Err(kk:ii));
        
        % update the sliding window by deleting the earliest entry and
        % adding the latest anomaly status
        slidingwindow = slidingwindow(2:end);
        slidingwindow(end+1) = MovAve(ii)>3; % 3 is the threshold
        
        % create an anomaly alert if 9/12 sliding window frames are
        % anomalous.
        if nnz(slidingwindow)>9
            AnomalyArray(max(ii-11,1):ii)=1;
            slidingwindow = zeros(1,12);
        end
    end
end

