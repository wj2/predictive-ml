function [  ] = plotAllGenRFs( ws, m, n, t )
for i = 1:size(ws, 1)
    plotGenRF(ws(i, :), m, n, t)
end
end

