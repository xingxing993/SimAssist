function sabt = regblock_inport
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Inport');
sabt.RoutineMethod = 'majorprop_str_num';
sabt.RoutinePattern = '^(inport|ipt|ip)';

sabt.ConnectPort = [0, 1];

sabt.MajorProperty = 'Name';
sabt.PropertyList = {'Name', 'Port'};
sabt.DictRenameMethod = 1;

sabt.PropagateUpstreamStringMethod = 'Name';
sabt.PropagateDownstreamStringMethod = 'Name';
sabt.OutportStringMethod = 'Name';

sabt.BlockSize = [30 14];

sabt.BlockPreferOption.ShowName = 'on';
sabt.BlockPreferOption.AutoDataType = false;

sabt.LayoutSize.VerticalMargin = 40;

sabt.DataTypeMethod = 'OutDataTypeStr';
sabt.DefaultDataType = 'Inherit: auto';

end