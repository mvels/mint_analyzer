function movement_peaks
[fnames, l_fnames, r_fnames] = get_fnames();

for i = 1:1
    fname = char(fnames(i));
    movement_data = csvread(['data/' fname]);
    [left_head, left_body, right_head, right_body] = noise_removal(movement_data);
    disp(size(left_head));
    
% %     lb_diff = right_body(:, 2) - right_body(:, 1);
%     lb_diff = left_body(:, 2) - left_body(:, 1);
%     lb_diff(lb_diff < 0) = 0;
%     
%     median_body = median(lb_diff);
%     disp(size(lb_diff));
%     disp(mean(lb_diff));
%     disp(median(lb_diff));
%     disp(max(lb_diff));
%     disp(min(lb_diff));
%     
%     body_threshold = median_body * 0.25; % 20% percent of the median body width is the threshold
%     lb_diff_norm = lb_diff - median_body;
%     lb_diff_norm(lb_diff_norm < body_threshold) = 0;
    [l_peaks, l_locs] = hand_movements(left_body, 0.25);
    [r_peaks, r_locs] = hand_movements(right_body, 0.25);
    figure
    hold on
    grid on
    tt = zeros(size(l_locs)) + 50;
    scatter(l_locs, tt, 'r', 'MarkerFaceColor' , 'r');
%     scatter(l_locs, l_peaks, 'r', 'MarkerFaceColor' , 'r');
%     scatter(r_locs, r_peaks, 'b', 'MarkerFaceColor' , 'b');
    
    
    
%     figure;
%     hold on;
%     grid on;
%     [peaks, locs] = findpeaks(left_head);
%     plot(locs, peaks, 'b');
% %     [peaks, locs] = findpeaks(left_head, 'minpeakdistance', 10);
% %     plot(locs, peaks, 'r');
% 
%     disp(size(locs));
% 
%     plot(left_body, 'g');
%     
%     [peaks, locs] = findpeaks(left_body(:, 1));
%     plot(locs, peaks, 'r');
% 
%     [peaks, locs] = findpeaks(left_body(:, 2));
%     plot(locs, peaks, 'r');
%     
%     disp(size(locs));
end
end