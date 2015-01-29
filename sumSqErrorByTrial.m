function [ prepped ] = sumSqErrorByTrial( error )
%sumSqErrorByTrial 
%   error - D x M*N
prepped = sum(error.^2, 2);
end

