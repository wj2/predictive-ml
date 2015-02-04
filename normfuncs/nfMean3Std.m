function [ stim ] = nfMean3Std( stim )
%nfMean2Std centers on mean and normalizes 3 stdev away
mu = mean2(stim);
stdev = std2(stim);

stim = (stim - mu) ./ (3*stdev) + .5;
stim(stim > 1) = 1;
stim(stim < 0) = 0;
end

