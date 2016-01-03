function sabt = regblock_merge
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Merge');
sabt.RoutineMethod = 'dynamicinport';
sabt.RoutinePattern = '^(mg|merge)';
sabt.RoutinePara.InportProperty = 'Inputs';

sabt.InportStringMethod = @inport_string;
sabt.OutportStringMethod = 1; % use name from inport 1


sabt.ArrangePortMethod{1} = 1;

sabt.MajorProperty = 'Inputs';

sabt.BlockSize = [25, 70];
sabt.AutoSizeMethod = -1;
sabt.DataTypeMethod = [];


sabt.LayoutSize.PortSpacing = 35;
sabt.LayoutSize.ToLineOffset = [50 100];

parbt = regblock_buscreator;
sabt.Inherit(parbt, 'PlusMethod', 'MinusMethod', 'CleanMethod');

end

function str = inport_string(hdl, appdata)
parblk = get_param(hdl, 'Parent');
parpts = get_param(parblk, 'PortHandles');
ptnum = get_param(hdl, 'PortNumber');
outstr = appdata.Console.GetDownstreamString(parpts.Outport);
str = [outstr, '_In', int2str(ptnum)];
end
