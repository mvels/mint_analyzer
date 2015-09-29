function all_speech_stats
[~, l_fnames, r_fnames] = get_fnames();
stats = zeros(23, 3 * 7 * 2);

for i = 1:size(l_fnames, 2)
% for i = 10:10
    lfname = char(l_fnames(i));
    rfname = char(r_fnames(i));
    disp(lfname);
    
    stats(i, 1:21) = calcAndFillStats(read_data(lfname));
    stats(i, 22:end) = calcAndFillStats(read_data(rfname));
end
assignin('base', 'speech_stats', stats);
csvwrite('speech_stats.csv', stats);
end

function stats = calcAndFillStats(data)
meta = speech_stats(data);
stats = zeros(1, 21);
stats(1, 1:7) = fillStats(meta.text);
stats(1, 8:14) = fillStats(meta.laugh);
stats(1, 15:21) = fillStats(meta.vocal);
end

function s = fillStats(data)
s = zeros(1, 7);
s(1) = data.count;
s(2) = data.length;
s(3) = data.mean;
s(4) = data.median;
s(5) = data.stdev;
s(6) = data.min;
s(7) = data.max;
end

function data = read_data(fname)
data = csvread(['data/' fname]);
data(:, 1:2) = data(:, 1:2) / 25 / 60;
end