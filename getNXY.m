function [ d_x, d_y ] = getNXY( data )
x = data(:, 1);
y = data(:, 2);

n = size(x{1}, 1);
g = size(x{1}, 2);
disp([n, g]);

x = cellfun(@(m) reshape(m, 1, g*n), x, 'UniformOutput', false);
d_x = cat(1, x{:});
d_y = cat(1, y{:});
end

