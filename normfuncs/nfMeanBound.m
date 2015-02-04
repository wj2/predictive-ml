function [ stim ] = nfMeanBound( stim )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
mu = mean2(stim);
stim = stim - mu + .5;
stim(stim > 1) = 1;
stim(stim < 0) = 0;
end

