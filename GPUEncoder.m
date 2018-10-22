function net = GPUEncoder(data,hs)
% GPUEncoder(data,hs) trains an autoencoder with the random number
% generator set to the default seed for reproducibility. This function uses
% the GPU as the default training component. The sparsity parameters and
% weights for the cost function are set as default so all networks are the
% same. The autoencoder object is then converted into a neural network
% object.

    % Set rng seed to default
    rng('default');
    
    % Train autoencoder using given properties
    autoenc = trainAutoencoder(data, hs,'UseGPU',true,...
    'L2WeightRegularization',0.005,'SparsityRegularization',4,...
    'SparsityProportion',0.05);

    % Convert autoencoder object into a network object
    net = network(autoenc);
end

