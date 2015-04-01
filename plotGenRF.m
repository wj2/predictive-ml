function [  ] = plotGenRF( w, m, n, t)
nw = size(w, 2);
w = w(:, 2:end);
figure; hold on; 
dim = ceil(sqrt(t));
wmax = max(w);
wmin = min(w);
w1 = w(1, :);
w2 = reshape(w1, t, m*n);
upw = reshape(w2', m, n, t);
for i = 1:t
    subplot(dim, dim, i); hold on;
    axis square;
    imagesc(reshape(upw(:, :, i), m, n));
    xlim([1, n]);
    ylim([1, m]);
    caxis([wmin, wmax]);
    colormap gray;
    hold off;
end
end

