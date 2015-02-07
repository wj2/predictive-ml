function [  ] = visualizePrediction( predOut, m, n, t )
%visualizePrediction : help visualize the results of the run
%   


%% make histograms of error
figure(); hold on;

subplot(2, 1, 1);
seenSSError = sumSqErrorByTrial(predOut.seen.error);
histogram(seenSSError);
title(sprintf('sum squared error for %i trained trials; m=%f, s=%f', ... 
    length(seenSSError), mean(seenSSError), std(seenSSError))); 

subplot(2, 1, 2);
unseenSSError = sumSqErrorByTrial(predOut.unseen.error);
histogram(unseenSSError);
title(sprintf('sum squared error for %i untrained trials; m=%f, s=%f', ... 
    length(unseenSSError), mean(unseenSSError), std(unseenSSError))); 
hold off;

%% make image of prediction vs truth
figure(); hold on;
[merr, mindex] = min(seenSSError);
subplot(1, 2, 1); 
origIm = reshape(predOut.seen.orig(mindex, :), m, n);
imagesc(origIm);
colormap gray;
title('original; seen');
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);

subplot(1, 2, 2); 
predIm = reshape(predOut.seen.predict(mindex, :), m, n);
imagesc(predIm);
colormap gray;
title(sprintf('predicted; seen; error=%f', merr));
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
hold off;

figure(); hold on;
[merr, mindex] = min(unseenSSError);
subplot(1, 2, 1); 
origIm = reshape(predOut.unseen.orig(mindex, :), m, n);
imagesc(origIm);
colormap gray; 
axis equal;
title('original; unseen');
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);

subplot(1, 2, 2); 
predIm = reshape(predOut.unseen.predict(mindex, :), m, n);
imagesc(predIm);
colormap gray;
axis equal;
pbaspect('manual');
title(sprintf('predicted; unseen; error=%f', merr));
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
hold off;

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
end

