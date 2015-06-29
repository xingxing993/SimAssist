function sabt = regblock_interpnd
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Interpolation_n-D');

sabt.RoutineMethod = @routine_interpnd;
sabt.RoutinePattern = '^(itp|interpnd)';


sabt.ConnectPort = [0, 1];

sabt.MajorProperty = 'Table';
sabt.DictRenameMethod = {'Table'};
sabt.DefaultParameters = {'AttributesFormatString','%<Table>','ExtrapMethod','None - Clip'};

sabt.LayoutSize.PortSpacing = 15;

sabt.PropagateDownstreamStringMethod = 'Table';
sabt.OutportStringMethod = 'Table';
sabt.AnnotationMethod = sprintf('%%<Table>');

sabt.BlockSize = [50, 50];

end


function [actrec, success] = routine_interpnd(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('Interpolation_n-D');
%parse input command
cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);
[result, bclean] = cmdpsr.ParseStringAndInteger;
if ~bclean 
    [actrec, success] = deal(saRecorder, false);return;
end

pvpair = {};
if ~isempty(result.String)
    pvpair = [pvpair, 'Table', result.String];
end
if ~isempty(result.Integer)
    pvpair = [pvpair, 'NumberOfTableDimensions', int2str(result.Integer)];
end
actrec = btobj.GenericContextAdd(pvpair{:});
success = true;
end