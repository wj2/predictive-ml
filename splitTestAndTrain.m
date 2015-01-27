function [ runs ] = splitTestAndTrain( data, testSet )
%splitTestAndTrain : splits dataset into testing and training sets
% the data is split s.t each element is in the test set exactly once
%  in:
%   data - 1 x D cell array
%   testSet - a fraction 0 < testSet < 1 indicating what percentage of the
%     dataset should be put in the bottom "test" row
%  out:
%   runs - 1 / testSet x 2 cell array; left column is training set, right 
%     column in same column is test set corresponding to that training set


sections = 1 / testSet;
sectionSize = testSet*length(data);
runs = cell(sections, 2);
for rotation = 1:sections
    rotMinOne = rotation - 1;
    pre = rotMinOne*sectionSize;
    post = rotation*sectionSize;
    trainingAllocPre = data(1:pre);
    trainingAllocPost = data(post+1:end);
    runs{rotation, 1} = [trainingAllocPre trainingAllocPost];
    runs{rotation, 2} = data(pre+1:post);
end
end

