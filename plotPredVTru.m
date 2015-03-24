function [ ] = plotPredVTru( origvid, predframe, ptitle )
figure; hold on;
suptitle(ptitle);
minf = min(min(origvid(:)), min(predframe));
maxf = max(max(origvid(:)), max(predframe));
t = size(origvid, 1);
m = size(origvid, 2);
n = size(origvid, 3);
predpic = reshape(predframe, m, n);
for i = 1:(t - 1)
    subplot(2, t, i); hold on;
    imagesc(reshape(origvid(i, :, :), m, n));
    colormap gray;
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    xlim([1, n]);
    ylim([1, m]);
    caxis([minf, maxf]);
    hold off;
    subplot(2, t, i+t); hold on;
    imagesc(reshape(origvid(i, :, :), m, n));
    colormap gray;
    xlim([1, n]);
    ylim([1, m]);
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    caxis([minf, maxf]);
    hold off;
end
subplot(2, t, t); hold on;
imagesc(reshape(origvid(t, :, :), m, n));
colormap gray;
xlim([1, n]);
ylim([1, m]);    
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
caxis([minf, maxf]);
title('original');
hold off;

subplot(2, t, t+t); hold on;
colormap gray;
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
caxis([minf, maxf]);
imagesc(predpic);
xlim([1, n]);
ylim([1, m]);    
title('predicted');
hold off;
hold off;
end

