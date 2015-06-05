function sabt = regblock_fromworkspace
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('FromWorkspace');

sabt.RoutineType = 'value_num';
sabt.RoutinePattern = '^(fromws|fromworkspace)';
sabt.RoutinePriority = 15;

sabt.BroBlockType = {'ToWorkspace'};
sabt.CreateBroBlockMethod = -1;
sabt.ConnectPort = [0, 1];

sabt.MajorProperty = 'VariableName';
sabt.DictRenameMethod = 1; % use major property
sabt.BlockSize = [70, 20];

sabt.PropagateDownstreamStringMethod = 'VariableName';
sabt.OutportStringMethod = 'VariableName';

sabt.RefineMethod = @refine_method;
end

function actrec = refine_method(blkhdl)
actrec = saRecorder;
tag = get_param(blkhdl, 'VariableName');
newval=[tag,'_',get_param(blkhdl,'BlockType')];
actrec.SetParam(blkhdl, 'Name', newval);
end