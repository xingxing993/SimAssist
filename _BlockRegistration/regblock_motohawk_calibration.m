function sabt = regblock_motohawk_calibration
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('MotoHawk_lib/Calibration & Probing Blocks/motohawk_calibration');

sabt.RoutinePattern = '^mh\s*(cal)';
sabt.RoutineMethod = @routine_motohawk_calibration;
sabt.RoutinePrompts = {'mhcal'};
sabt.RoutinePriority = 20;


sabt.ConnectPort = [0, 1];
sabt.MajorProperty = 'nam';
sabt.DictRenameMethod = {'nam', 'val'};

parbt = regprotoblock_motohawk_general;
sabt.Inherit(parbt, ...
    'PropagateDownstreamStringMethod',...
    'RefineMethod',...
    'DataTypeMethod');

sabt.InportStringMethod = 'val';
sabt.OutportStringMethod = 'val';

sabt.BlockSize = [20, 25];
sabt.LayoutSize.CharWidth = 8;
sabt.AutoSizeMethod = -2; % rightwards expand to show string
end


function [actrec, success] = routine_motohawk_calibration(cmdstr, console)
saLoadLib('MotoHawk_lib');
btobj = console.MapTo('MotoHawk Calibration');
cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);
[result, bclean] = cmdpsr.ParseNumericAndString;
if ~bclean [actrec, success]=deal(saRecorder, false); end
[num, val] = deal(result.NumericStr, result.String);

if isempty(num) && isempty(val)
    pvpair = {};
elseif isempty(num) && ~isempty(val)
    pvpair = {'nam', ['''',val,''''], 'val', val};
elseif ~isempty(num) && isempty(val)
    pvpair={'val', num};
else
    pvpair={'nam', ['''',val,''''], 'val', num};
end
[actrec, success] = btobj.GenericContextAdd(pvpair{:});
end