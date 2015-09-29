function [peaks, locs] = hand_movements(data, body_threshold_percent)
if nargin < 2
    body_threshold_percent = 0.25;
end

body_diff = data(:, 2) - data(:, 1);
body_diff(body_diff < 0) = 0;
median_body = median(body_diff);

% 20% percent of the median body width is the threshold
body_threshold = median_body * body_threshold_percent;
body_diff_norm = body_diff - median_body;
body_diff_norm(body_diff_norm < body_threshold) = 0;
%     plot(body_diff_norm, 'c');
[peaks, locs] = findpeaks(body_diff_norm);
end