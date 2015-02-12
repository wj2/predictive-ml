function [ ofvids ] = getOpticFlow( vids, n )
%getOpticFlow : calculate optic flow of cell array of videos
%   vids - Dx1 cell array of KxMxN videos
%   n - number of last frames to calculate optic flow for
of = vision.OpticalFlow;
ofvids = cell(1, length(vids));
for i = 1:length(vids)
    vid = vids{i};
    fl = zeros(n, size(vid, 2), size(vid, 3));
    s = size(vid, 1);
    step(of, reshape(vid(s-n, :, :), size(vid, 2), size(vid, 3)));
    for j = s-n+1:s
        fl(j-s+n, :, :) = step(of, reshape(vid(j, :, :), ... 
            size(vid, 2), size(vid, 3)));
    end
    ofvids{i} = fl;
end
end

