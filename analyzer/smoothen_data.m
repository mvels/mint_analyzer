function smooth_data = smoothen_data(data)
smooth_data = data;
for i = 1:size(data, 2)
    smooth_data(:, i) = smoothen_curve(smooth_data(:, i));
end
end

function new_data = smoothen_curve(data)
new_data = data .* 0;
win_left = 2;
win_right = 3;
iterations = 5;
for t=1:iterations
    for i = win_left + 1:size(data, 1) - win_right
        new_data(i) = mean(data(i - win_left:i + win_right));
    end
    data = new_data;
end
end
