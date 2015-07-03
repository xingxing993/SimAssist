function sabt = regblock_motohawk_probe
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('MotoHawk_lib/Calibration & Probing Blocks/motohawk_probe');

sabt.RoutinePattern = '^mh\s*(prb|probe)';
sabt.RoutineMethod = @routine_motohawk_probe;
sabt.RoutinePrompts = {'mh prb', 'mh probe'};
sabt.RoutinePriority = 20;

sabt.ConnectPort = [1, 0];

sabt.MajorProperty = 'nam';
sabt.DictRenameMethod = {'nam'};

parbt = regprotoblock_motohawk_general;
sabt.Inherit(parbt, ...
    'InportStringMethod',...
    'OutportStringMethod',...
    'PropagateUpstreamStringMethod',...
    'RefineMethod');

sabt.BlockSize = [20, 25];
sabt.LayoutSize.CharWidth = 6;
sabt.AutoSizeMethod = -3; % rightwards expand to show string
end


function [actrec, success] = routine_motohawk_probe(cmdstr, console)
actrec=saRecorder;success = false;
saLoadLib('MotoHawk_lib');
btobj = console.MapTo('MotoHawk Probe');
cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);
[result, bclean] = cmdpsr.ParseStringAndInteger;
if ~bclean [actrec, success]=deal(saRecorder, false); return;end
if isempty(result.String)
    pvpair = {};
else
    pvpair = {'nam', ['''',result.String,'''']};
end
actrec + btobj.GenericContextAdd(result.Integer, pvpair{:});
success = true;
end