function [mrf, mstim] = motionDetectPE(stim, rfs, m, n, t, samp)

%% filters
fourierFilt = [0, 0, 0; 1, 0, 1];
nonFourierSpatFilt = [0, 0, 0; 1, 0, 0; 1, 0, 1; 2, 0, 1];
gliderFilt = [0, 0, 0; 1, 0, 0; 0, 0, 1];

filtbank = {fourierFilt, nonFourierSpatFilt, gliderFilt};

%% populations
stim = stim(randsample(1:length(stim), samp));
stim = cellfun(@(x) permute(x, [2, 3, 1]), stim, 'UniformOutput', false);
rfcell = cell(size(rfs, 1), 1);
for i = 1:size(rfs, 1)
    w = reshape(rfs(i, 2:end), t, m, n);
    w = permute(w, [2, 3, 1]);
    rfcell{i} = w;
end

disp('doing rfs');
mrf = getMotionFromPop(rfcell, filtbank);
disp('doing stims');
mstim = getMotionFromPop(stim, filtbank);