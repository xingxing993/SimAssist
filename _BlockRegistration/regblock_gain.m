function sabt = regblock_gain
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Gain');

sabt.RoutineMethod = 'majorprop_value';
sabt.RoutinePattern = '^gain';

sabt.MajorProperty = 'Gain';

sabt.BlockSize = [30, 30];
sabt.StrReplaceMethod = 1;
end