function [lhead, lbody, rhead, rbody] = noise_removal(data)
[lhead, rhead] = get_head_data(data);
[lbody, rbody] = get_body_data(data);

lhead = get_head_center(fix_data_noise(lhead, 'L'));
rhead = get_head_center(fix_data_noise(rhead, 'R'));

lbody = fix_data_noise(lbody, 'L');
rbody = fix_data_noise(rbody, 'R');

% close all;
% figure;
% hold on;
% grid on;
% grid minor;
% plot([lhead, lbody, rhead, rbody]);
% legend('LH', 'LBL', 'LBR', 'RH', 'RBL', 'RBR');
end

function cdata = get_head_center(data)
cdata = data(:, 1) + (data(:, 2) - data(:, 1)) / 2;
end

function [left, right] = get_head_data(data)
left = [data(:, 10), data(:, 10) + data(:, 12)];
right = [data(:, 14), data(:, 14) + data(:, 16)];
end

function [left, right] = get_body_data(data)
left = [data(:, 18), data(:, 18) + data(:, 20)];
right = [data(:, 22), data(:, 22) + data(:, 24)];
end

function new_data = fix_data_noise(data, side)
new_data = data;

if side == 'L'
    back = 1;
    front = 2;
else
    back = 2;
    front = 1;
end

% finding median values from non-zero values of coordinates
median_back = median(data(data(:, back) > 0, back));
median_front = median(data(data(:, front) > 0, front));
% starting from the first frame that has coordinates
start_frame = find(data(:, 1), 1, 'first');

for i = start_frame:size(data, 1)
    % check if the back coordinate exceeds front coordinate
    if (side == 'L' && data(i, back) > data(i, front)) || (side == 'R' && data(i, back) < data(i, front))
        new_data(i, back) = median_back;
        new_data(i, front) = median_front;
    end
    if data(i, back) == 0 || data(i, front) == 0
        new_data(i, back) = median_back;
        new_data(i, front) = median_front;
    end
    if abs(new_data(i, back) - median_back) > 100
        new_data(i, back) = median_back;
    end
    if abs(new_data(i, front) - median_front) > 100
        new_data(i, front) = median_front;
    end
end

% in case of right person, he/she comes from the right of the scene (640)
% replacing all the initial zero-coordinates with 640-values
if side == 'R'
    new_data(1:start_frame, :) = 640;
end

end