function [ ofvids ] = getOpticFlow( vids, k )
%getOpticFlow : calculate optic flow of cell array of videos
%   vids - Dx1 cell array of KxMxN videos
%   n - number of last frames to calculate optic flow for
of = vision.OpticalFlow;
ofvids = cell(1, length(vids));

for i = 1:length(vids)
    vid = vids{i};
    m = size(vid, 2);
    n = size(vid, 3);
    s = size(vid, 1);
    fl = zeros(k, m, n);
    step(of, reshape(vid(s-k, :, :), m, n));
    for j = s-k+1:s
        fl(j-s+k, :, :) = step(of, reshape(vid(j, :, :), m, n));
    end
    ofvids{i} = fl;
end
end

