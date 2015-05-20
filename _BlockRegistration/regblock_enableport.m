function sabt = regblock_enableport
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('EnablePort');

sabt.RoutineType = 'value_only';
sabt.RoutinePattern = '^(en|enable)';
sabt.RoutinePriority = 40;

sabt.BlockSize = [20, 20];
end