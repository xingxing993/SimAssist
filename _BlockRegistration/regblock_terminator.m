function sabt = regblock_terminator
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Terminator');
sabt.RoutineType = 'value_num';
sabt.RoutinePattern = '^(term|terminator)';

sabt.ConnectPort = [1, 0];
end