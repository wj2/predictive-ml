function [ motion ] = motionDetect( v, filt, varargin )
parser = inputParser;
parser.addRequired('v', @isnumeric);
parser.addRequired('filt', @isnumeric);
parser.addParameter('binarize', true, @islogical);
parser.parse(v, filt, varargin);
v = parser.Results.v;
filt = parser.Results.filt;
binar = parser.Results.binarize;

if binar
    mv = median2(v);
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
        mlum = median2(lum);
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



end

