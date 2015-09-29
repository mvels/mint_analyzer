function speech_hand_correlation_statistics
[fnames, l_fnames, r_fnames] = get_fnames();

moves_stats = zeros(23, 8);

for i = 1:23
    fname = char(fnames(i));
    disp(fname);
    [l_sh_data, r_sh_data, l_moves, r_moves] = get_sh_data(fname, char(l_fnames(i)), char(r_fnames(i)));
%     find_hand_move_distance_from_speech(l_sh_data, l_moves);
%     find_hand_move_distance_from_speech(r_sh_data, r_moves);
    moves_stats(i, 1:4) = l_moves;
    moves_stats(i, 5:8) = r_moves;
end
disp(moves_stats);
end

function [l_sh_data, r_sh_data, l_moves, r_moves] = get_sh_data(m_fname, l_fname, r_fname)
movement_data = csvread(['data/' m_fname]);
l_speech_data = csvread(['data/' l_fname]);
r_speech_data = csvread(['data/' r_fname]);
[l_th, r_th] = hand_movement_thresholds();

[left_head, left_body, right_head, right_body] = noise_removal(movement_data);
[l_peaks, l_locs] = hand_movements(left_body, l_th);
[r_peaks, r_locs] = hand_movements(right_body, r_th);
[l_sh_data, l_moves] = speech_hand_correlation(l_speech_data, l_locs);
[r_sh_data, r_moves] = speech_hand_correlation(r_speech_data, r_locs);
end

function find_hand_move_distance_from_speech(sh_data, move_data)
% dist = sh_data(:, 3) - sh_data(:, 1);
% disp(frame2time(mean(dist)));
% disp(frame2time(median(dist)));
% disp(frame2time(std(dist)));
disp(move_data);
disp('===');
end