function [ storage ] = trainML( train_x, train_y, test_x, test_y, ...
    netstruc, varargin )
parser = inputParser;
parser.addRequired('train_x', @isnumeric);
parser.addRequired('train_y', @isnumeric);
parser.addRequired('test_x', @isnumeric);
parser.addRequired('test_y', @isnumeric);
parser.addRequired('netstruc', @isnumeric);
parser.addParameter('batchsize', 1, @isnumeric);
parser.addParameter('numepochs', 50, @isnumeric);
parser.addParameter('seenSamplesFactor', .1, @isnumeric);
parser.addParameter('pretrain', false, @islogical);
parser.addParameter('prebatch', 5, @isnumeric);
parser.addParameter('prepochs', 20, @isnumeric);
parser.addParameter('alpha', .01, @isnumeric);
parser.addParameter('l2decay', .0001, @isnumeric);
parser.addParameter('actFunc', 'sigm');
parser.addParameter('sparsePenalty', true, @islogical);
parser.parse(train_x, train_y, test_x, test_y, netstruc, varargin{:});

train_x = parser.Results.train_x;
train_y = parser.Results.train_y;
test_x = parser.Results.test_x;
test_y = parser.Results.test_y;
netstruc = parser.Results.netstruc;
opts.batchsize = parser.Results.batchsize;
opts.numepochs = parser.Results.numepochs;
seenSamplesFactor = parser.Results.seenSamplesFactor;
pretrain = parser.Results.pretrain;
prebatch = parser.Results.prebatch;
prepochs = parser.Results.prepochs;
l2dec = parser.Results.l2decay;
alpha = parser.Results.alpha;
actFunc = parser.Results.actFunc;
sparsePen = parser.Results.sparsePenalty;

if pretrain
    %% unsupervised pretraining
    dbn.sizes = netstruc(2:end-1);
    dopts.numepochs = prepochs;
    dopts.batchsize = prebatch;
    dopts.alpha = alpha;
    dopts.momentum = 0;
    disp(min(train_x(:)));
    disp(max(train_x(:)));
    dbn = dbnsetup(dbn, train_x, dopts);
    dbn = dbntrain(dbn, train_x, dopts);
    
    nn = dbnunfoldtonn(dbn, netstruc(end));
else
    nn = nnsetup(netstruc);
end
%% supervised training
% train on subset of data
nn.activation_function = actFunc;
nn.learningRate = alpha;
nn.weightPenaltyL2 = l2dec;
nn.nonSparsityPenalty = sparsePen;
[nn, L] = nntrain(nn, train_x, train_y, opts);

% test on unseen data
nnUS = nnff(nn, test_x, test_y);

% test on random subset of seen data
seenSamplesTest = round(seenSamplesFactor*size(train_x, 1));
randomRows = randsample(1:size(train_x, 1), seenSamplesTest);
rstrain_x = train_x(randomRows, :);
rstrain_y = train_y(randomRows, :);
nnS = nnff(nn, rstrain_x, rstrain_y);
testedseenvids = train_x;
testedseenvids = testedseenvids(randomRows, :);

storage.net.trainedNet = nn;
storage.net.trainingSSError = L;
storage.stim = {train_x, test_x};
storage.testedseenstim = testedseenvids;
storage.unseen.error = nnUS.e;
storage.unseen.sserror = nnUS.L;
storage.unseen.orig = test_y;
storage.unseen.predict = nnUS.a{end};
storage.seen.error = nnS.e;
storage.seen.sserror = nnS.L;
storage.seen.orig = rstrain_y;
storage.seen.predict = nnS.a{end};

end

