function speech_hand_movement_diagram(movement_data, l_speech_data, r_speech_data, timeRange)
[left_head, left_body, right_head, right_body] = noise_removal(movement_data);
frames_minute = 25 * 60;
time = (1:size(left_head, 1)) / frames_minute;
min_time = timeRange(1);
max_time = timeRange(2);
if min_time >= 0 && max_time > 0
    tidx = time(:) >= min_time & time(:) < max_time;
else
    tidx = time(:) > 0;
end

[l_th, r_th] = hand_movement_thresholds();
[l_peaks, l_locs] = hand_movements(left_body, l_th);
[r_peaks, r_locs] = hand_movements(right_body, r_th);

% l_locs = get_location_subset_for_time_frame(l_locs, min_time * frames_minute, max_time * frames_minute);
% r_locs = get_location_subset_for_time_frame(r_locs, min_time * frames_minute, max_time * frames_minute);
[l_sh_data, l_moves] = speech_hand_correlation(l_speech_data, l_locs);
[r_sh_data, r_moves] = speech_hand_correlation(r_speech_data, r_locs);
disp(l_moves);
disp(r_moves);

% time_offset = min(time(tidx));

draw_diagram(l_sh_data(:, 3) / (25 * 60), r_sh_data(:, 3) / (25 * 60));
end

function new_data = get_location_subset_for_time_frame(loc_data, min_frames, max_frames)
new_data = loc_data(loc_data(:, 1) >= min_frames & loc_data(:, 1) <= max_frames, 1);
end

function draw_diagram(left_hands, right_hands)
circle_size = 50;
left_vertical = zeros(size(left_hands)) + 55;
scatter(left_hands, left_vertical, circle_size, 'r', 'MarkerFaceColor' , 'r');
hold on;
right_vertical = zeros(size(right_hands)) + 545;
scatter(right_hands, right_vertical, circle_size, 'r', 'MarkerFaceColor' , 'r');
end