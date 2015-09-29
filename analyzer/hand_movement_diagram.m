function  hand_movement_diagram(data, showLegend, timeRange)
[left_head, left_body, right_head, right_body] = noise_removal(data);
[l_th, r_th] = hand_movement_thresholds();
time = (1:size(left_head, 1)) / (25 * 60);
min_time = timeRange(1);
max_time = timeRange(2);
if min_time >= 0 && max_time > 0
    tidx = time(:) >= min_time & time(:) < max_time;
else
    tidx = time(:) > 0;
end

[l_peaks, l_locs] = hand_movements(left_body(tidx, :), l_th);
[r_peaks, r_locs] = hand_movements(right_body(tidx, :), r_th);

time_offset = min(time(tidx));

% plot(l_locs, l_peaks, 'r');
draw_diagram(time(l_locs) + time_offset, time(r_locs) + time_offset);
end

function draw_diagram(left_hands, right_hands)
circle_size = 20;
circle_color = 'r';
% xlabel('Time (minutes)');
% ylabel('Horizontal position (pixels)');
left_vertical = zeros(size(left_hands)) + 55;
scatter(left_hands, left_vertical, circle_size, circle_color, 'MarkerFaceColor' , circle_color);
hold on;
right_vertical = zeros(size(right_hands)) + 545;
scatter(right_hands, right_vertical, circle_size, circle_color, 'MarkerFaceColor' , circle_color);
end