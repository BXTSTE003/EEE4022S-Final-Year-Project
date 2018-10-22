function AnomalyDetection(filename,flownet,pixelnet)
%AnomalyDetection(filename,flownet,pixelnet) takes a test video, and the
%two trained networks and calculates where both sets of anomalies are in
%the video, then plots those two arrays together.
    
    % obtain the flow anomaly array.
    [flowAnomaly] = PredictF(flownet,filename);
    
    % obtain the pixel anomaly array.
    [t,pixelAnomaly] = PredictP(pixelnet,filename);
    
    % plot and scale the arrays so the difference can be seen.
    plot(t,1.02*flowAnomaly,'-',t,0.98*pixelAnomaly,'--');
    
    % set the ylimit so the anomalies can be seen better.
    ylim([0 1.5]);
    
    % adjust the ticks on the xaxis to multiples of 2 so the time of the
    % anomaly is easier to see from the graph, and label the xaxis as the
    % time axis.
    maxt = ceil(max(t));
    if mod(maxt,2)
        maxt = maxt+1;
    end
    xticks(0:2:maxt);
    xlabel('Time (s)');
    
    % resize the figure to full size and create a legend.
    set(gcf,'Position',get(0,'Screensize'));
    legend('Flow Anomalies','Pixel Anomalies');
end

