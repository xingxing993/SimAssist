function sabt = regblock_enableport
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('EnablePort');

sabt.RoutineMethod = 'majorprop_value';
sabt.RoutinePattern = '^(en|enable)';
sabt.RoutinePriority = 40;

sabt.MajorProperty = 'Name';

sabt.BlockSize = [20, 20];
end