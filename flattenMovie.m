function [ flatmov ] = flattenMovie( mov, varargin )
parser = inputParser;
parser.addRequired('mov');
parser.addParameter('frames', 1, @isnumeric);
parser.parse(mov, varargin{:});

mov = parser.Results.mov;
frms = parser.Results.frames;

m = size(mov, 1);
n = size(mov, 2);
% flatmov = cellfun(@(x) reshape(x, m*n, 1), num2cell(mov, [1, 2]), ...
%     'UniformOutput', false);

flatmov = zeros(m*n*frms, size(mov, 3));
mmov = mean2(mov);
for i = 1:size(mov, 3);
    buff = ones(m, n, max(0, frms - i)) * mmov;
    sec = mov(:, :, max(1, i - frms + 1):i);
    assert(size(buff, 3) + size(sec, 3) == frms);
    flatmov(:, i) = reshape(cat(3, buff, sec), m*n*frms, 1);
end
% flatmov = cat(2, flatmov{:});
end

