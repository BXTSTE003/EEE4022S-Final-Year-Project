function net = RetrainNet(net,data)
% RetrainNet(net,data) retrains the given autoencoder network using the GPU
% as the default training component. 'data' is the X and T in this training
% because an autoencoder tries to replicate the input at its output.
    
    % Syntax for train is train(net,X,T), where net is the network that is
    % being retrained, X is the training data and T is the targets.
    net = train(net,data,data,'UseGPU','yes');
end

