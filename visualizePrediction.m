function [  ] = visualizePrediction( predOut, m, n, t )
%visualizePrediction : help visualize the results of the run
%   

%% make histograms of error
figure(); hold on;

subplot(2, 1, 1);
seenSSError = sumSqErrorByTrial(predOut.seen.error);
histogram(seenSSError);
title(sprintf('sum squared error for %i trained trials; m=%.2f, s=%.2f', ... 
    length(seenSSError), mean(seenSSError), std(seenSSError))); 

subplot(2, 1, 2);
unseenSSError = sumSqErrorByTrial(predOut.unseen.error);
histogram(unseenSSError);
title(sprintf('sum squared error for %i untrained trials; m=%.2f, s=%.2f', ... 
    length(unseenSSError), mean(unseenSSError), std(unseenSSError))); 
hold off;

%% make image of prediction vs truth

% for seen
[merr, mindex] = min(seenSSError);
seenstim = predOut.stim{1};
origvid = seenstim{mindex};
predframe = predOut.seen.predict(mindex, :);
plottitle = sprintf('sse = %.2f; seen', merr);
plotPredVTru(origvid, predframe, plottitle);

% for unseen
[merr, mindex] = min(unseenSSError);
unseenstim = predOut.stim{2};
origvid = unseenstim{mindex};
predframe = predOut.unseen.predict(mindex, :);
plottitle = sprintf('sse = %.2f; unseen', merr);
plotPredVTru(origvid, predframe, plottitle);

% figure(); hold on;
% [merr, mindex] = min(seenSSError);
% subplot(3, 2, 1); 
% origIm = reshape(predOut.seen.orig(mindex, :), m, n);
% imagesc(origIm);
% colormap gray;
% title('original; seen');
% set(gca, 'XTickLabel', []);
% set(gca, 'YTickLabel', []);
% 
% subplot(3, 2, 2); 
% predIm = reshape(predOut.seen.predict(mindex, :), m, n);
% imagesc(predIm);
% colormap gray;
% title(sprintf('predicted; seen; error=%f', merr));
% set(gca, 'XTickLabel', []);
% set(gca, 'YTickLabel', []);
% hold off;
% 
% figure(); hold on;
% [merr, mindex] = min(unseenSSError);
% subplot(1, 2, 1); 
% origIm = reshape(predOut.unseen.orig(mindex, :), m, n);
% imagesc(origIm);
% colormap gray; 
% axis equal;
% title('original; unseen');
% set(gca, 'XTickLabel', []);
% set(gca, 'YTickLabel', []);
% 
% subplot(1, 2, 2); 
% predIm = reshape(predOut.unseen.predict(mindex, :), m, n);
% imagesc(predIm);
% colormap gray;
% axis equal;
% pbaspect('manual');
% title(sprintf('predicted; unseen; error=%f', merr));
% set(gca, 'XTickLabel', []);
% set(gca, 'YTickLabel', []);
% hold off;

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

%% get optic flow error
[oferr, pfl, ofl] = opticFlowError(predOut.unseen.predict, ...
    predOut.stim{2});
absmean = @(x) mean2(abs(x));
mofl = cell2mat(cellfun(absmean, ofl, 'UniformOutput', false));
mpfl = cell2mat(cellfun(absmean, pfl, 'UniformOutput', false));
figure; hold on;
scatter(mofl, mpfl, 'filled', 'LineWidth', 1);
xlabel('mean original flow');
ylabel('mean predicted flow');
maxmean = max(max(mofl), max(mpfl));
xlim([0, maxmean]);
ylim([0, maxmean]);
hold off;
figure; hold on;
scatter(oferr, mofl, 'filled', 'LineWidth', 1);
xlabel('flow mse');
ylabel('mean original flow');
hold off;
figure; hold on;
scatter(oferr, unseenSSError, 'filled', 'LineWidth', 1);
xlabel('flow mse');
ylabel('all mse');
hold off;
figure; hold on;
scatter(mofl, unseenSSError, 'filled', 'LineWidth', 1);

end

