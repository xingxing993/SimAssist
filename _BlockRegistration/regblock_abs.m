function sabt = regblock_abs
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Abs');
sabt.RoutineType = 'value_num';
sabt.RoutinePattern = '^abs';

sabt.BlockSize = [30, 30];

end