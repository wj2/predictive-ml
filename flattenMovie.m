function [ flatmov ] = flattenMovie( mov )
m = size(mov, 1);
n = size(mov, 2);
flatmov = cellfun(@(x) reshape(x, m*n, 1), num2cell(mov, [1, 2]), ...
    'UniformOutput', false);
flatmov = cat(2, flatmov{:});
end

