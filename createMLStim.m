function [ stims ] = createMLStim( movie, rows, cols, frames, n )
%createMLStim : processes TxMxN natural movies for use in PE
%   movies - TxMxN dim array
%   rows - number of rows to include in stimulus patches
%   cols - number of columns to include in stimulus patches
%   frames - number of frames to include in stimulus patches
%   n - number of stimuli to create

stims = cell(1, n);
tstarts = randi(size(movie, 1) - frames, 1, n);
rstarts = randi(size(movie, 2) - rows, 1, n);
cstarts = randi(size(movie, 3) - cols, 1, n);
for i = 1:n
    stims{i} = movie(tstarts:tstarts+frames-1, rstarts:rstarts+rows-1,...
        cstarts:cstarts+cols-1);
end
end

