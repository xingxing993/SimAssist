function sabt = regblock_abs
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Abs');

sabt.RoutinePattern = '^abs';
sabt.RoutineMethod = 'num_only';


sabt.BlockSize = [30, 30];

end