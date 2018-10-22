function [AnomalyArray] = PredictF(flownet,filename)
%PredictF(flownet,filename) takes in a flow network and a test file and
%determines the location of anomalies, based on errors between the
%autoencoder's predicted output and the input.

    % obtain the optical flow data and calculate how many samples are in
    % the data.
    data = ReadFlowData(filename);
    samples = size(data,2);
    
    % preallocate the variables for speed.
    Err = zeros(1,samples);
    MovAve = zeros(1,samples);
    AnomalyArray = zeros(1,samples);
    slidingwindow = zeros(1,12);

    % loop through the samples.
    for ii=1:samples
        % obtain the value of the current sample.
        currsample = data(:,ii);
        
        % predict the autoencoder's output.
        test = flownet(currsample,'UseGPU','yes');
        
        % calculate the prediction error.
        E = currsample{1} - test{1};
        
        % determine what percentage of the predicitions are outliers.
        outlier = isoutlier(E,'gesd');
        Err(ii) = 100*nnz(outlier)/7200;
        
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
        % adding the latest anomaly status.
        slidingwindow = slidingwindow(2:end);
        slidingwindow(end+1) = MovAve(ii)>3.5; % 3.5 is the threshold
        
        % create an anomaly alert if 9/12 sliding window frames are
        % anomalous.
        if nnz(slidingwindow)>9
            AnomalyArray(max(ii-11,1):ii)=1;
            slidingwindow = zeros(1,12);
        end
    end
end

