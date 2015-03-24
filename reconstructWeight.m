function [ wm, dwm ] = reconstructWeight( wv, m, n, t )
wm = zeros(m, n*t);
dwm = zeros(m, n*(t-1));
wmpre = reshape(wv, t, m, n);
for i = 1:t
    wm(:, (i-1)*n + 1:n*i) = wmpre(i, :, :);
    if i > 1
        dwm(:, (i-2)*n + 1:n*(i-1)) = wmpre(i, :, :) - wmpre(i-1, :, :);
    end
end
end