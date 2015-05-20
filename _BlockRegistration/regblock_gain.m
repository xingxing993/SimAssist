function sabt = regblock_gain
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Gain');

sabt.RoutineType = 'value_only';
sabt.RoutinePattern = '^gain';

sabt.MajorProperty = 'Gain';

sabt.BlockSize = [30, 30];

end