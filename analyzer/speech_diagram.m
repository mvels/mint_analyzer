function speech_diagram(l_data, r_data, timeRange, divideByMinutes)
if nargin < 4
    divideByMinutes = false;
end
lspeech = frames2time(l_data);
rspeech = frames2time(r_data);
draw_diagram(lspeech, rspeech, divideByMinutes, timeRange);
end

function draw_diagram(lspeech, rspeech, divideByMinutes, timeRange)
min_time = timeRange(1);
max_time = timeRange(2);
if min_time >= 0 && max_time > 0
    lidx = lspeech(:, 2) >= min_time & lspeech(:, 2) < max_time;
    ridx = rspeech(:, 2) >= min_time & rspeech(:, 2) < max_time;
else
    lidx = lspeech(:, 2) > 0;
    ridx = rspeech(:, 2) > 0;
end

max_time = max(max(lspeech(lidx, 2)), max(rspeech(ridx, 2)));
full_minutes = round(max_time) + 1;

lmeta = get_diagram_meta_data_left(divideByMinutes);
lmeta.full_minutes = full_minutes;
rmeta = get_diagram_meta_data_right(divideByMinutes);
rmeta.full_minutes = full_minutes;

show_speech(lspeech(lidx, :), lmeta, divideByMinutes);
show_speech(rspeech(ridx, :), rmeta, divideByMinutes);
end

function diagram_info = get_diagram_meta_data_left(divideByMinutes)
light_blue = [153 204 255] / 255;
blue_dark = [0 0 0.5];
blue = [0 0 1.0];
diagram_info.text_col = light_blue;
diagram_info.laugh_col = blue;
diagram_info.vocal_col = blue_dark;

if divideByMinutes
    diagram_info.ver_height = 0.4;
    diagram_info.laugh_pos = 1.5;
    diagram_info.text_pos = 1.0;
    diagram_info.vocal_pos = 0.5;
else
    diagram_info.ver_height = 30;
    diagram_info.laugh_pos = 70;
    diagram_info.text_pos = 40;
    diagram_info.vocal_pos = 10;
end
end

function diagram_info = get_diagram_meta_data_right(divideByMinutes)
green = [0 1 0];
green_dark = [0 128 0] / 255;
light_green = [154 255 153] / 255;
diagram_info.text_col = light_green;
diagram_info.laugh_col = green;
diagram_info.vocal_col = green_dark;
if divideByMinutes
    diagram_info.ver_height = 0.4; % 0.4
    diagram_info.laugh_pos = 2.5; % 3.5
    diagram_info.text_pos = 3.0; % 3.0
    diagram_info.vocal_pos = 3.5; % 2.5
else    
    diagram_info.ver_height = 30;
    diagram_info.laugh_pos = 500;
    diagram_info.text_pos = 530;
    diagram_info.vocal_pos = 560;
end
end

function data = frames2time(data)
data(:, 1:2) = data(:, 1:2) / 25 / 60;
end

function show_speech(data, diag_meta, divide_by_minutes)
cur_minute = floor(min(data(:, 2)));

for i = 1:size(data, 1)
    if divide_by_minutes && data(i, 2) > cur_minute
        cur_minute = cur_minute + 1;
        createSubPlot(cur_minute, diag_meta.full_minutes);
    end
    [faceColor, vertPos] = getMetaValuesForType(data(i, 3), diag_meta);
    rectangle('Position', [data(i, 1), vertPos, data(i, 2) - data(i, 1), ...
        diag_meta.ver_height], 'LineWidth', 1, 'LineStyle', 'none', 'FaceColor', faceColor);
end
if ~divide_by_minutes
    addFakePlotsForLegend(diag_meta);
end
end

function addFakePlotsForLegend(meta)
plot(1, 1, 'Color', meta.text_col, 'linewidth', 5);
plot(1, 1, 'Color', meta.laugh_col, 'linewidth', 5);
plot(1, 1, 'Color', meta.vocal_col, 'linewidth', 5);
end

function createSubPlot(cur_minute, full_minutes)
subplot(full_minutes, 1, cur_minute);
xlim([cur_minute - 1 cur_minute]);
ylim([0 4]);
newYTickLabels = assignSideLabels(get(gca, 'YTickLabel'));
set(gca, 'YTickLabel', newYTickLabels);
newXTickLabels = assignTimeLabels(get(gca, 'XTickLabel'));
set(gca, 'XTickLabel', newXTickLabels);
grid on;
end

function [faceColor, vertPos] = getMetaValuesForType(type, meta)
if type == 0
    faceColor = meta.text_col;
    vertPos = meta.text_pos;
elseif type < 3
    faceColor = meta.laugh_col;
    vertPos = meta.laugh_pos;
else
    faceColor = meta.vocal_col;
    vertPos = meta.vocal_pos;
end
end

function newLabels = assignSideLabels(labels)
if labels(1, 1) == 'L'
    newLabels = labels;
    return;
end

newLabels = 'L';
for i = 2:size(labels, 1)
    newLabels(i, :) = ' ';
end
newLabels(end, :) = 'R';
end

function newLabels = assignTimeLabels(labels)
% if we have already converted once, then return
if labels(1, 2) == ':'
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
