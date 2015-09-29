function time_str = frame2time(frame)
seconds = frame / 25;
minutes = seconds / 60;
intpart = floor(minutes);
decpart = floor(seconds - intpart * 60);
subsec = round((seconds - intpart * 60 - decpart) * 100);
time_str = sprintf('%d:%02d.%02d', intpart, decpart, subsec);
end