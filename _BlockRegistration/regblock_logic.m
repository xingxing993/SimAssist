function sabt = regblock_logic
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Logic');

sabt.RoutineMethod = @routine_logical;
sabt.RoutinePara.InportProperty = 'Inputs';
sabt.RoutinePattern = '^(and|or|not|xor|nor|nand)';

sabt.ArrangePortMethod{1} = 1;
sabt.BlockPreferOption.AutoDataType = false;

sabt.MajorProperty = 'Operator';

sabt.InportStringMethod = @inport_string;
sabt.OutportStringMethod = @outport_string;
sabt.RollPropertyMethod = -1;

sabt.BlockSize = [25, 70];
sabt.AutoSizeMethod = -1;
sabt.DataTypeMethod = [];

sabt.LayoutSize.ToLineOffset = [50 100];

parbt = regblock_buscreator;
sabt.Inherit(parbt, 'PlusMethod', 'MinusMethod', 'CleanMethod');

end


function str = inport_string(hdl, appdata)
parblk = get_param(hdl, 'Parent');
parpts = get_param(parblk, 'PortHandles');
ptnum = get_param(hdl, 'PortNumber');
opstr = get_param(parblk, 'Operator');
outstr = appdata.Console.GetDownstreamString(parpts.Outport);
str = [outstr, '_', opstr, int2str(ptnum)];
end

function str = outport_string(hdl, appdata)
parblk = get_param(hdl, 'Parent');
parpts = get_param(parblk, 'PortHandles');
opstr = get_param(parblk, 'Operator');
instr = cellstr(appdata.Console.GetUpstreamString(parblk));
str = [opstr, '_', instr{:}];
end


function [actrec, success] =routine_logical(cmdstr, console)
btobj = console.MapTo('Logic');
cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);
[actrec, success] = Routines.dynamicinport(btobj, cmdpsr.OptionStr, '', ...
    'Operator', cmdpsr.PatternStr);
end