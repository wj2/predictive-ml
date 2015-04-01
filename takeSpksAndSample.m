function [ keep ] = takeSpksAndSample( resp )
spkinds = find(resp >= 1);
otherinds = find(resp == 0);
keepothers = randsample(otherinds, length(spkinds));
keep = [keepothers, spkinds];
end

