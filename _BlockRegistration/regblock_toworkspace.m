function sabt = regblock_toworkspace
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('ToWorkspace');
sabt.MajorProperty = 'VariableName';
sabt.DictRenameMethod = 1; % use major property
sabt.BlockSize = [70, 20];

sabt.RoutineMethod = 'majorprop_str_num';
sabt.RoutinePattern = '^(tows|toworkspace)';
sabt.RoutinePriority = 15;

sabt.PropagateUpstreamStringMethod = 'VariableName';
sabt.InportStringMethod = 'VariableName';
sabt.RefineMethod = @refine_method;
end

function actrec = refine_method(blkhdl)
actrec = saRecorder;
tag = get_param(blkhdl, 'VariableName');
newval=[tag,'_',get_param(blkhdl,'BlockType')];
actrec.SetParam(blkhdl, 'Name', newval);
end