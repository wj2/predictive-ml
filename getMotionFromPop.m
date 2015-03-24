function [ msigs ] = getMotionFromPop( vign, filts )
msigs = zeros(length(vign), length(filts));
for v = 1:length(vign)
    for f = 1:length(filts)
        ms = motionDetect(vign{v}, filts{f});
        msigs(v, f) = mean(ms(:));
    end
end
end

