function [ zipped ] = zipToCell( one, two, dim )
assert(length(one) == length(two));
zipped = cell(1, length(one));
for i = 1:length(one)
    zipped{i} = cat(dim, one{i}, two{i});
end
end

