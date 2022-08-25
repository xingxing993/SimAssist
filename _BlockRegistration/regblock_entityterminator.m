function sabt = regblock_entityterminator
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('EntityTerminator');
sabt.RoutineMethod = 'num_only';
sabt.RoutinePattern = '^(entityterm)';

sabt.PropagateUpstreamStringMethod = 'Name';

sabt.ConnectPort = [1, 0];
end