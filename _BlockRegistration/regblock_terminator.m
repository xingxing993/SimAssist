function sabt = regblock_terminator
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Terminator');
sabt.RoutineMethod = 'num_only';
sabt.RoutinePattern = '^(terminator|term)';

sabt.PropagateUpstreamStringMethod = 'Name';

sabt.ConnectPort = [1, 0];
end