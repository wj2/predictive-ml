function [ train, test ] = makeTrainAndTest( stim, resp, n, trainsize )

inds = setdiff(takeSpksAndSample(resp), 1:n);
shuffind = inds(randperm(length(inds)));
partition = floor(trainsize*length(shuffind));
trainind = shuffind(1:partition);
testind = shuffind(partition+1:end);
train = cell(length(trainind), 2);
for i = 1:length(trainind)
    ind = trainind(i);
    s = stim(ind-n+1:ind, :);
    r = resp(ind, :);
    train{i, 1} = s;
    train{i, 2} = r;
end

test = cell(length(testind), 2);
for i = 1:length(testind)
    ind = testind(i);
    s = stim(ind-n+1:ind, :);
    r = resp(ind, :);
    test{i, 1} = s;
    test{i, 2} = r;
end
disp(size(train));
disp(size(test));
end

