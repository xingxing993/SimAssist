function sabt = regblock_math
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Math');

sabt.RoutineType = 'value_num';
sabt.RoutinePattern = '^math';

sabt.MajorProperty = 'Operator';
sabt.RollPropertyMethod = -1;
end