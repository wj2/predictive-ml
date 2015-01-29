function [ storage ] = predictiveEncoder( dataset, testSet, varargin)
%predictiveAutoEncoder : trains and tests a PAE using the DLT by Berg Palm
%   dataset - should be 1 x D cell vector of T x M x N arrays
%     T - time dimension, T = n + 1 (n may be inferred from the value of T)
%     M x N - image dimensions, should be consistent for all elements in
%       the vector
%     D - size of dataset
%   testSet - fraction of dataset to test predictions on; number of
%     training trials = (1 - testSet) * D; number of test 
%     trials = testSet * D
parser = inputParser;
parser.addRequired('dataset', @iscell);
parser.addRequired('testSet', @isnumeric);
parser.addParameter('hiddenUnits', 200, @isnumeric);
parser.addParameter('batchsize', 1, @isnumeric);
parser.addParameter('numepochs', 50, @isnumeric);
parser.addParameter('seenSamplesFactor', .1, @isnumeric);
parser.addParameter('numRuns', 1 / testSet, @isnumeric);
parser.parse(dataset, testSet, varargin{:});

dataset = parser.Results.dataset;
testSet = parser.Results.testSet;
hiddenUnits = parser.Results.hiddenUnits;
opts.batchsize = parser.Results.batchsize;
opts.numepochs = parser.Results.numepochs;
seenSamplesFactor = parser.Results.seenSamplesFactor;
numRuns = parser.Results.numRuns;

d = length(dataset);
pieceShape = size(dataset{1});
t = pieceShape(1);
steps = t - 1;
m = pieceShape(2);
n = pieceShape(3);

shuffData = dataset(randperm(d));
% runs is 1 / testSet x 2; first row is training, second is test
runs = splitTestAndTrain(shuffData, testSet, 'numRuns', numRuns);

% we have 1 / testSet runs to go through
% for each run, we want to train on the training set and then test the
% predictor on the test set and quantify the performance
% we will also run the autoencoder on some of the sets it was trained on to
% explore how well it is able to "denoise" the images after training
% 
% in both cases, we will have an M x N array produced by the autoencoder
% (that is, the predicted image yi) and the M x N array we wanted to produce
% *with* the encoder (that is, xi) -- ||xi - yi||^2, nn.e stores xi - yi or
% something

% storage = cell(1, 1 / testSet);
% storage = struct(1, 1 / testSet);
for i = 1:numRuns
    % train on subset of data
    [train_x, train_y] = getXandY(runs{i, 1}, steps);
    nn = nnsetup([m*n*steps hiddenUnits m*n]);
    nn.activation_function = 'sigm';
    nn.learningRate = .1;
    nn.weightPenaltyL2 = .00001;
    [nn, L] = nntrain(nn, train_x, train_y, opts);
    
    % test on unseen data
    [test_x, test_y] = getXandY(runs{i, 2}, steps);
    nnUS = nnff(nn, test_x, test_y);
    
    % test on random subset of seen data
    seenSamplesTest = round(seenSamplesFactor*size(train_x, 1));
    randomRows = randsample(1:size(train_x, 1), seenSamplesTest);
    rstrain_x = train_x(randomRows, :);
    rstrain_y = train_y(randomRows, :);
    nnS = nnff(nn, rstrain_x, rstrain_y);
    
    storage(i).net.trainedNet = nn;
    storage(i).net.trainingSSError = L;
    storage(i).unseen.error = nnUS.e;
    storage(i).unseen.sserror = nnUS.L;
    storage(i).unseen.orig = test_y;
    storage(i).unseen.predict = nnUS.a{end};
    storage(i).seen.error = nnS.e;
    storage(i).seen.sserror = nnS.L;
    storage(i).seen.orig = rstrain_y;
    storage(i).seen.predict = nnS.a{end};
end
end

