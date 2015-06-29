function sabt = regblock_sum
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Sum');

sabt.RoutinePattern = '^[+-]+';
sabt.RoutineMethod = @routine_plus_minus;


sabt.MajorProperty = 'Inputs';

sabt.OutportStringMethod = 1;
sabt.InportStringMethod = 1;

sabt.BlockSize = [25, 70];
sabt.AutoSizeMethod = -1;

sabt.LayoutSize.PortSpacing = 35;
sabt.LayoutSize.ToLineOffset = [50 100];
end


function [actrec, success] = routine_plus_minus(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('Sum');
cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);
if numel(cmdpsr.PatternStr)==1
    operator = ['+', cmdpsr.PatternStr];
else
    operator = cmdpsr.PatternStr;
end
[operand, bclean] = cmdpsr.ParseValueString;
if ~bclean [actrec, success]=deal(saRecorder, false); end

[actrec2, block] = btobj.AddBlock('Inputs', operator); actrec.Merge(actrec2);
if ~isempty(operand) %add 2nd operand
    btobjcnst = console.MapTo('Constant');
    pts = get_param(block, 'PortHandles');
    option.PropagateString = false;
    actrec + btobjcnst.AddBlockToPort(pts.Inport(2), option, 'Value', operand);
else
    srchdls = saFindSystem(gcs,'line_sender');
    if ~isempty(srchdls)
        actrec.MultiAutoLine(srchdls, block);
    end
end
success = true;
end