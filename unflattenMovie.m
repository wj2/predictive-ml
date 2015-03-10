function [ mov ] = unflattenMovie( flmov, m, n)

mov = cellfun(@(x) reshape(x, m, n), num2cell(flmov, 1), ...
    'UniformOutput', false);
mov = cat(3, mov{:});
end

