function [ ] = genPatchImages( mov, t, m, n, name )
stim = createMLStim(mov, m, n, t, 1, @nfMean3Std);
for i = 1:t
    imwrite(reshape(stim{1}(i, :, :), m, n), ...
        strcat(name, num2str(i), '.png'));
end
end

