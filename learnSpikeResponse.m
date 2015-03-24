function [ results ] = learnSpikeResponse( stim, resp, n, hidden, ...
    varargin )
% stim - MxGxK
% resp - FxK
parser = inputParser;
parser.addRequired('stim');
parser.addRequired('resp');
parser.addRequired('n', @(x) x >= 1);
parser.addRequired('hidden', @isnumeric);
parser.addParameter('trainparams', struct(), @isstruct);
parser.addParameter('trainsize', .8, @isnumeric);
parser.parse(stim, resp, n, hidden, varargin{:});
stim = parser.Results.stim;
resp = parser.Results.resp;
n = parser.Results.n;
hidden = parser.Results.hidden;
trainsize = parser.Results.trainsize;
trainparams = parser.Results.trainparams;

m = size(stim, 1);
g = size(stim, 2);
f = size(resp, 2);
assert(m == size(resp, 1));
netStruc = [g, hidden, f];
[train, test] = makeTrainAndTest(stim, resp, n, trainsize);
[train_x, train_y] = getNXY(train);
[test_x, test_y] = getNXY(test);

results = trainML(train_x, train_y, test_x, test_y, netStruc, ...
    trainparams);
end

