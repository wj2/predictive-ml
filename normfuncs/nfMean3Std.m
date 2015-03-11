function [ stim ] = nfMean3Std( stim, varargin )
%nfMean3Std centers on mean and normalizes 3 stdev away
parser = inputParser;
parser.addRequired('stim', @isnumeric);
parser.addParameter('minval', double(0), @isnumeric);
parser.addParameter('maxval', double(1), @isnumeric);
parser.addParameter('prec', @double);
parser.parse(stim, varargin{:});
stim = parser.Results.stim;
minval = parser.Results.minval;
maxval = parser.Results.maxval;
prec = parser.Results.prec;

mu = mean2(stim);
stdev = std2(stim);
stim = double(stim);
if stdev == 0
    stim = zeros(size(stim)) + mean([minval, maxval]);
else
    stim = (maxval - minval)*((stim - mu) ./ (3*stdev)) + ...
        mean([minval, maxval]);
end
stim(stim >= maxval) = maxval;
stim(stim <= minval) = minval;
stim = prec(stim);
end

