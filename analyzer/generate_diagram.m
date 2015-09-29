function generate_diagram
[fnames, l_fnames, r_fnames] = get_fnames();

saveFlag = false;
showLegend = false;
timeRange = [3 4];
% figureSize = [0, 0, 1000, 300];
figureSize = [0, 0, 900, 335];
files_total = size(fnames, 2);
% files_total = 18;
% for i = 1:files_total
for i = 5:5
    fname = char(fnames(i));
    disp(fname);
    movement_data = csvread(['data/' fname]);
    l_speech_data = csvread(['data/' char(l_fnames(i))]);
    r_speech_data = csvread(['data/' char(r_fnames(i))]);
    h = false;
    h = movement_diagram(movement_data, showLegend, timeRange);
    speech_diagram(l_speech_data, r_speech_data, timeRange, false);
    hand_movement_diagram(movement_data, showLegend, timeRange);
%     speech_hand_movement_diagram(movement_data, l_speech_data, r_speech_data, timeRange);
    if timeRange(2) > 0
        xlim(timeRange);
    end
    if h
        addLegend();
        set(h, 'Position', figureSize);
    end
    if saveFlag
        save_diagram(h, fname, 'png', figureSize);
    end
end
end

function save_diagram(h, ofname, extension, figureSize)
set(gcf,'PaperUnits','inches','PaperPosition', figureSize / 100);
print(h, [ofname(1:end - 4) '.' extension], ['-d' extension], '-r100');
close(h);
end

function addLegend
hleg = legend('LBB', 'LBF', 'LH',...
    'RBF', 'RBB', 'RH', ...
    'LS', 'LL', 'LV', ...
    'RS', 'RL', 'RV', 'LHM', 'RHM');
set(hleg, 'Orientation', 'horizontal', 'Location', 'NorthOutside', 'FontSize', 10, 'FontWeight', 'normal');
end
