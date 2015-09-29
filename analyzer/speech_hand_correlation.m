function [speech_hand, matches_moves] = speech_hand_correlation(speech_data, hand_data)
speech_hand = zeros(size(speech_data));
matches_moves = zeros(1, 4);
matches_moves(1) = size(hand_data, 1);
for i = 1:size(speech_data, 1)
    
    hand_moves = hand_data(hand_data >= speech_data(i, 1) & hand_data <= speech_data(i, 2));
    if size(hand_moves, 1) > 0
        if speech_data(i, 3) == 0    
            speech_hand(i, 1:2) = speech_data(i, 1:2);
            speech_hand(i, 3) = min(hand_moves);
        end
        s_type = get_speech_type(speech_data(i, 3));
        matches_moves(s_type) = matches_moves(s_type) + size(hand_moves, 1);
    end
end

% disp(size(hand_data));
% disp(matches_moves);
speech_hand = speech_hand(speech_hand(:, 1) > 0, :);
end

function new_type = get_speech_type(type)
if type == 0
    new_type = 2;
elseif type < 3
    new_type = 3;
else
    new_type = 4;
end
end