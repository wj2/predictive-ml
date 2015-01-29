function [ wm, dwm ] = reconstructWeight( wv, m, n, t )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
wm = zeros(m, n*t);
dwm = zeros(m, n*(t-1));
insz = m*n;
for i = 1:t
    wm(:, (i-1)*n + 1:n*i) = reshape(wv(insz*(i-1) + 1:insz*i), m, n);
    if i > 1
       dwm(:, (i-2)*n + 1:n*(i-1)) = wm(:, (i-1)*n + 1:n*i) - ...
           wm(:, (i-2)*n + 1:n*(i-1));
    end
end
end

