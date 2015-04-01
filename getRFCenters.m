function [ cents ] = getRFCenters( rfdata )
cents = zeros(length(rfdata), 2);
for i = 1:length(rfdata)
    rfs = rfdata{i};
    rfs = max(abs(rfs - mean2(rfs)), [], 3);
    maxcol = max(rfs, [], 1);
    maxcind = find(maxcol == max(maxcol));
    cents(i, 2) = maxcind(1);
    maxrow = max(rfs, [], 2);
    maxrind = find(maxrow == max(maxrow));
    cents(i, 1) = maxrind(1);
end
end

