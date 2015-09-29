function  h = movement_diagram(data, showLegend, timeRange)
smoothFlag = false;

% start_col: 2: Full Body, 10: Head, 18: Body, 26: Legs
[left_head, left_body, right_head, right_body] = noise_removal(data);
if smoothFlag
    left_head = smoothen_data(left_head);
    left_body = smoothen_data(left_body);
    right_head = smoothen_data(right_head);
    right_body = smoothen_data(right_body);
end

h = draw_diagram(left_head, left_body, right_head, right_body, timeRange);
if showLegend
    addLegend();
end
end

function h = draw_diagram(left_head, left_body, right_head, right_body, timeRange)
time = (1:size(left_head, 1)) / (25 * 60);
min_time = timeRange(1);
max_time = timeRange(2);
if min_time >= 0 && max_time > 0
    tidx = time(:) >= min_time & time(:) < max_time;
else
    tidx = time(:) > 0;
end
assignin('base', 'tidx', tidx);
h=figure;
hold on;
xlabel('Time (minutes)');
ylabel('Horizontal position (pixels)');
blue = [0 0 1.0];
blue_dark = [0 0 0.5];
indigo = [75 0 130] / 255;
plot(time(tidx), left_body(tidx, 1), 'Color', blue_dark, 'linewidth', 2);
plot(time(tidx), left_body(tidx, 2), 'Color', blue, 'linewidth', 2);
plot(time(tidx), left_head(tidx, 1), 'Color', indigo, 'linewidth', 2);

green = [0 1 0];
green_dark = [0 0.5 0];
medium_green = [60 179 113] / 255;
plot(time(tidx), right_body(tidx, 1), 'Color', green, 'linewidth', 2);
plot(time(tidx), right_body(tidx, 2), 'Color', green_dark, 'linewidth', 2);
plot(time(tidx), right_head(tidx, 1), 'Color', medium_green, 'linewidth', 2);

newXTickLabels = assignTimeLabels(get(gca, 'XTickLabel'));
set(gca, 'XTickLabel', newXTickLabels);

grid on;
% grid minor;
end

function newLabels = assignTimeLabels(labels)
% if we have already converted once, then return
if size(labels, 2) > 1 && labels(1, 2) == ':'
    newLabels = labels;
    return;
end
newLabels = '0:00';
for i = 1:size(labels, 1)
    tval = str2double(labels(i, :));
    intpart = floor(tval);
    decpart = round((tval - intpart) * 60);
    tstr = sprintf('%d:%02d', intpart, decpart);
    newLabels(i, :) = tstr;
end
end

function addLegend
hleg = legend('L.Body Back', 'L.Body Front', 'L.Head', 'R.Body Front', 'R.Body Back', 'R.Head');
set(hleg, 'Location', 'NorthEast', 'FontSize', 16, 'FontWeight', 'bold');
end
