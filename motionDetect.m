function [ mosigs ] = motionDetect( v, filt, varargin )
parser = inputParser;
parser.addRequired('v', @isnumeric);
parser.addRequired('filt', @isnumeric);
parser.addParameter('binarize', false, @islogical);
parser.parse(v, filt, varargin{:});
v = parser.Results.v;
filt = parser.Results.filt;
binar = parser.Results.binarize;

if binar
    mv = median(v(:));
    v(v >= mv) = 1;
    v(v < mv) = -1;
end

    function [rfilt] = revFilt(filt, dir)
        maxondir = max(filt, [], 1);
        maxondir = maxondir(dir);
        rfilt = filt;
        rfilt(:, dir) = maxondir - rfilt(:, dir);
    end

    function [sco] = rawCorr(x, y, t, lum, filt)
        sco = 1;
        mlum = median(lum(:));
        for i = 1:size(filt, 1)
            trip = filt(i, :);
            sco = sco*(lum(x + trip(1), y + trip(2), t + trip(3)) - mlum);
        end
    end

    function [lmo] = localMotion(x, y, t, lum, filt, dir)
        lmo = (rawCorr(x, y, t, lum, filt) - ...
            rawCorr(x, y, t, lum, revFilt(filt, dir))) - ...
            (rawCorr(x, y, t, lum, revFilt(filt, 3)) - ...
            rawCorr(x, y, t, lum, revFilt(revFilt(filt, dir), 3)));
    end

randv = normrnd(mean(v(:)), std(v(:)), size(v));
randv(randv >= 1) = 1;
randv(randv <= 0) = 0;
buff = max(filt(:));
mosigs = zeros(size(v, 1) - buff, size(v, 2) - buff, size(v, 3) - buff);
lmo = zeros(size(mosigs, 1), size(mosigs, 2), size(mosigs, 3));
ranlmo = zeros(size(mosigs, 1), size(mosigs, 2), size(mosigs, 3));
for x = 1:size(mosigs, 1);
    for y = 1:size(mosigs, 2);
        for t = 1:size(mosigs, 3);
            lmo(x, y, t) = localMotion(x, y, t, v, filt, 1).^2;
            ranlmo(x, y, t) = localMotion(x, y, t, randv, filt, 1).^2;
            disp(ranlmo(x,y,t));
        end
    end
end
mosigs = mean2(lmo) / mean2(ranlmo);
end

