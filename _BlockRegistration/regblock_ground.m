function sabt = regblock_ground
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Ground');

sabt.RoutineType = 'value_num';
sabt.RoutinePattern = '^(gnd|ground)';

sabt.BlockSize = [20, 20];
sabt.ConnectPort = [0, 1];
end