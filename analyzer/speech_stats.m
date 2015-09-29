function meta = speech_stats(data)
text = data(data(:, 3) == 0, 1:2);
laugh = data(data(:, 3) > 0 & data(:, 3) < 3, 1:2);
vocal = data(data(:, 3) == 3, 1:2);

meta.text = get_speech_stats(text * 60);
meta.laugh = get_speech_stats(laugh * 60);
meta.vocal = get_speech_stats(vocal * 60);
end

function s = get_speech_stats(data)
t_diff = data(:, 2) - data(:, 1);
s = init_stats();
s.count = size(t_diff, 1);
if s.count > 0
    s.length = sum(t_diff);
    s.mean = mean(t_diff);
    s.median = median(t_diff);
    s.stdev = std(t_diff);
    s.min = min(t_diff);
    s.max = max(t_diff);
end
end

function s=init_stats
s.count = 0;
s.length = 0;
s.mean = 0;
s.median = 0;
s.stdev = 0;
s.min = 0;
s.max = 0;
end