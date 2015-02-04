function [ stim ] = nfBinarize( stim )
%nfBinarize given 3D stimulus that varies on [0, 1], binarizes based on
%           mean
%   stim - TxMxN stimulus
mu = mean2(stim);
stim(stim >= mu) = 1;
stim(stim < mu) = 0;
end

