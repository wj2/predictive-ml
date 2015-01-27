function [ x, y ] = getXandY( data, xframes )
%getXandY : converts cell array of stimuli to x and y for ML
%   data - 1xD cell array with TxMxN arrays in each cell
dsize = size(data{1});
x = zeros(length(data), (xframes*dsize(2)*dsize(3)));
y = zeros(length(data), (dsize(1) - xframes)*dsize(2)*dsize(3));
for i = length(data)
    d = data{i};
    xpre = d(1:xframes, :, :);
    ypre = d(1:dsize(1) - xframes, :, :);
    x(i, :) = reshape(xpre, 1, size(x, 2));
    y(i, :) = reshape(ypre, 1, size(y, 2));
end
end

