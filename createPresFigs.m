function [  ] = createPresFigs( predOut, m, n, t )
%visualizePrediction : help visualize the results of the run
%   

%% make histograms of error
figure(); hold on;
unseenSSError = sumSqErrorByTrial(predOut.unseen.error);
histogram(unseenSSError);
title(sprintf('sum squared error for %i untrained trials; m=%.2f, s=%.2f', ... 
    length(unseenSSError), mean(unseenSSError), std(unseenSSError))); 
print(gcf, '-dpng', '-r300', '../present/figs/fullerror-hist.png');
hold off;

%% make image of prediction vs truth

% for unseen
[merr, mindex] = min(unseenSSError);
unseenstim = predOut.stim{2};
origvid = unseenstim{mindex};
predframe = predOut.unseen.predict(mindex, :);
plottitle = sprintf('sse = %.2f; unseen', merr);
plotPredVTru(origvid, predframe, plottitle);
print(gcf, '-dpng', '-r300', '../present/figs/minerror-prediction.png');

% avg prediction
[~, meanindex] = min(abs(unseenSSError - mean(unseenSSError)));
origvid = unseenstim{meanindex};
predframe = predOut.unseen.predict(meanindex, :);
plottitle = sprintf('sse = %.2f; unseen', mean(unseenSSError));
plotPredVTru(origvid, predframe, plottitle);
print(gcf, '-dpng', '-r300', '../present/figs/meanerror-prediction.png');

%% make images of weights
figure(); hold on;
title('weight reconstructions');
weights = predOut.net.trainedNet.W{1};
numweights = size(weights, 1);
reconnedWeights = cell(numweights, 1);
reconnedDWeights = cell(numweights, 1);
plotdim = ceil(sqrt(numweights));
for i = 1:numweights 
   subplot(plotdim, plotdim, i);
   [wm, dwm] = reconstructWeight(weights(i, 2:end), m, n, t);
   imagesc(wm);
   set(gca, 'XTickLabel', []);
   set(gca, 'YTickLabel', []);
   colormap gray;
   reconnedWeights{i} = wm;
   reconnedDWeights{i} = dwm;
end
hold off;
print(gcf, '-dpng', '-r300', '../present/figs/allrf-tiled.png');

figure(); hold on;
title('weight reconstructions, temporal');
for i = 1:numweights
   subplot(plotdim, plotdim, i);
   imagesc(reconnedDWeights{i});
   set(gca, 'XTickLabel', []);
   set(gca, 'YTickLabel', []);
   colormap gray;
end
hold off;
print(gcf, '-dpng', '-r300', '../present/figs/allrf-tiled-diff.png');

chosenRF = 18*7;
cRF = reconnedWeights{chosenRF};
cRF1 = cRF(:, 1:n);
cRF2 = cRF(:, n+1:end);

figure; hold on;
imagesc(cRF1);
title('t_1');
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
xlim([1, n]);
ylim([1, m]);
colormap gray;
hold off;
print(gcf, '-dpng', '-r300', '../present/figs/crf1.png');

figure; hold on;
imagesc(cRF2);
title('t_2');
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
xlim([1, n]);
ylim([1, m]);
colormap gray;
hold off;
print(gcf, '-dpng', '-r300', '../present/figs/crf2.png');

figure; hold on;
imagesc(reconnedDWeights{chosenRF});
title('t_2 - t_1');
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
xlim([1, n]);
ylim([1, m]);
colormap gray;
hold off;
print(gcf, '-dpng', '-r300', '../present/figs/dcrf.png');

figure(); hold on;
weights = predOut.net.trainedNet.W{2}';
weights = weights(2:end, :);
numweights = size(weights, 1);
reconnedOutWeights = cell(numweights, 1);
plotdim = ceil(sqrt(numweights));
for i = 1:numweights 
   subplot(plotdim, plotdim, i);
   wm = reshape(weights(i, :), m, n);
   imagesc(wm);
   set(gca, 'XTickLabel', []);
   set(gca, 'YTickLabel', []);
   colormap gray;
   reconnedOutWeights{i} = wm;
end
suptitle('all t_3');
hold off;
print(gcf, '-dpng', '-r300', '../present/figs/allrft3-tiled.png');

figure; hold on;
imagesc(reconnedOutWeights{chosenRF});
title('t');
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
xlim([1, n]);
ylim([1, m]);
colormap gray;
hold off;
print(gcf, '-dpng', '-r300', '../present/figs/crf3.png');

figure(); hold on;
weights = predOut.net.trainedNet.W{1};
numweights = size(weights, 1);
reconnedWeights = cell(numweights, 1);
reconnedDWeights = cell(numweights, 1);
plotdim = ceil(sqrt(numweights));
for i = 1:numweights 
   subplot(plotdim, plotdim, i);
   wm = reshape(weights(i, 2:end), t, m, n);
   imagesc(reshape(wm(1, :, :), m, n));
   set(gca, 'XTickLabel', []);
   set(gca, 'YTickLabel', []);
   colormap gray;
   reconnedWeights{i} = wm;
   reconnedDWeights{i} = dwm;
end
suptitle('all t_1');
hold off;
print(gcf, '-dpng', '-r300', '../present/figs/allrft1-tiled.png');

figure(); hold on;
weights = predOut.net.trainedNet.W{1};
numweights = size(weights, 1);
reconnedWeights = cell(numweights, 1);
reconnedDWeights = cell(numweights, 1);
plotdim = ceil(sqrt(numweights));
for i = 1:numweights 
   subplot(plotdim, plotdim, i);
   wm = reshape(weights(i, 2:end), t, m, n);
   imagesc(reshape(wm(2, :, :), m, n));
   set(gca, 'XTickLabel', []);
   set(gca, 'YTickLabel', []);
   colormap gray;
   reconnedWeights{i} = wm;
   reconnedDWeights{i} = dwm;
end
suptitle('all t_2');
hold off;
print(gcf, '-dpng', '-r300', '../present/figs/allrft2-tiled.png');

%% get optic flow error
[oferr, pfl, ofl, sfl] = opticFlowError(predOut.unseen.predict, ...
    predOut.stim{2});
absmean = @(x) mean2(abs(x));
mofl = cell2mat(cellfun(absmean, ofl, 'UniformOutput', false));
mpfl = cell2mat(cellfun(absmean, pfl, 'UniformOutput', false));
msfl = cell2mat(cellfun(absmean, sfl, 'UniformOutput', false));

figure; hold on;
histogram(mofl);
title(sprintf('mean optical flow for %i untrained trials; m=%.2f, s=%.2f', ... 
    length(mofl), mean(mofl), std(mofl))); 
xlabel('mean optical flow on prediction step')
ylabel('count');
hold off;
print(gcf, '-dpng', '-r300', '../present/figs/mofl-histo.png');

figure; hold on;
flowtrials = unseenSSError(mofl >= mean(mofl));
histogram(flowtrials);
title(sprintf('error on trials with above average flow; m=%.2f, s=%.2f', ... 
    mean(flowtrials), std(flowtrials))); 
xlabel('mse')
ylabel('count');
hold off;
print(gcf, '-dpng', '-r300', '../present/figs/error-flowtrial-histo.png');

figure; hold on;
scatter(mofl, mpfl, 'filled', 'LineWidth', 1);
xlabel('mean original flow');
ylabel('mean predicted flow');
h = refline(1, 0);
h.Color = 'r';
maxmean = max(max(mofl), max(mpfl));
xlim([0, maxmean]);
ylim([0, maxmean]);
lsline;
[r, p] = corrcoef(mofl, mpfl);
title(sprintf('actual vs predicted flow; r2 = %.2f; p = %.3f', ...
    r(2,1)^2, p(2,1)));
hold off;
print(gcf, '-dpng', '-r300', '../present/figs/oflow-pflow.png');

figure; hold on;
scatter(oferr, mofl, 'filled', 'LineWidth', 1);
xlabel('flow mse');
ylabel('mean original flow');
lsline;
hold off;

figure; hold on;
scatter(oferr, unseenSSError, 'filled', 'LineWidth', 1);
xlabel('flow mse');
ylabel('all mse');
hold off;

figure; hold on;
scatter(mofl, unseenSSError, 'filled', 'LineWidth', 1);
xlabel('mean flow');
ylabel('mse');
lsline;
[r, p] = corrcoef(mofl, unseenSSError);
title(sprintf('flow vs prediction MSE; r2 = %.2f; p = %.3f', ...
    r(2,1)^2, p(2,1)));
hold off;
print(gcf, '-dpng', '-r300', '../present/figs/oflow-mse.png');

figure; hold on;
scatter(msfl, mpfl, 'filled', 'LineWidth', 1);
xlabel('seen flow');
ylabel('predicted flow');
h = refline(1, 0);
h.Color = 'r';
lsline; 
maxmean = max(max(msfl), max(mpfl));
xlim([0, maxmean]);
ylim([0, maxmean]);
[r, p] = corrcoef(msfl, mpfl);
title(sprintf('seen step flow vs predicted flow; r2 = %.2f; p = %.3f', ...
    r(2,1)^2, p(2,1)));
hold off;
print(gcf, '-dpng', '-r300', '../present/figs/sflow-pflow.png');

figure; hold on;
scatter(msfl, mofl, 'filled', 'LineWidth', 1);
xlabel('seen flow');
ylabel('original flow');
maxmean = max(max(msfl), max(mofl));
xlim([0, maxmean]);
ylim([0, maxmean]);
hold off;
end

