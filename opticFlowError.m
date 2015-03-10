function [ sserrs, predfl, origfl ] = opticFlowError( pred, origvids )
%opticFlowError : calculates error in optic flow between original and
%                 prediction
%   pred - Kx(M*N) double where each row is a different predicted stimulus
%   origvids - 1xK cell of FxMxN doubles where each cell is the original
%     F-frame video for the corresponding prediction
predfl = cell(1, length(origvids));
origfl = cell(1, length(origvids));
sserrs = zeros(1, length(origvids));
for i = 1:length(origvids)
    vid = origvids{i}; % FxMxN
    predframe = reshape(pred(i, :), 1, size(vid, 2), size(vid, 3));
    predvid = cat(1, vid(1:end-1, :, :), predframe);
    fls = getOpticFlow({predvid vid}, 1);
    predfl{i} = fls{1};
    origfl{i} = fls{2};
    errs = (predfl{i} - origfl{i}).^2;
    sserrs(i) = sum(errs(:));
end
end

