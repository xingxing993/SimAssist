function sabt = regblock_mux
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Mux');
sabt.RoutineType = 'dynamicinport';
sabt.RoutinePattern = '^mux';
sabt.RoutinePara.InportProperty = 'Inputs';


sabt.OutportStringMethod = @inport_string;

sabt.SourcePath = 'Mux';
sabt.BlockSize = [5, 70];

sabt.DefaultParameters = {'DisplayOption', 'bar'};

sabt.LayoutSize.PortSpacing = 30;

parobj = regblock_buscreator; % inherit from BusCreator
sabt.Inherit(parobj, 'PlusMethod', 'MinusMethod');
end

function str = inport_string(pthdl, appdata)
parblk = get_param(pthdl, 'Parent');
ptnum = get_param(pthdl, 'PortNumber');
outstr = cellstr(appdata.Console.GetDownstreamString(parblk));
str = [outstr, '_D', int2str(ptnum)];
end