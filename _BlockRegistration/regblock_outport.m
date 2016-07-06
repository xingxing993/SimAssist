function sabt = regblock_outport
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Outport');
sabt.RoutineMethod = 'majorprop_str_num';
sabt.RoutinePattern = '^(outport|opt|op)';

sabt.ConnectPort = [1, 0];
sabt.MajorProperty = 'Name';
sabt.PropertyList = {'Name', 'Port'};

sabt.DictRenameMethod = 1;

sabt.PropagateDownstreamStringMethod = 'Name';
sabt.PropagateUpstreamStringMethod = 'Name';
sabt.InportStringMethod = 'Name';

sabt.BlockSize = [30 14];

sabt.BlockPreferOption.ShowName = 'on';
sabt.BlockPreferOption.AutoDataType = false;

sabt.AnnotationMethod = 'Disable Action: %<OutputWhenDisabled>';

sabt.DataTypeMethod = 'OutDataTypeStr';
sabt.DefaultDataType = 'Inherit: auto';
end
