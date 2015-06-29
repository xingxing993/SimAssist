function sabt = regblock_product
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Product');

sabt.RoutinePattern = '^[*/]+';
sabt.RoutineMethod = @routine_multiply_divide;

parsabt = regblock_sum;
sabt.Inherit(parsabt);

end


function [actrec, success] =routine_multiply_divide(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('Product');
cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);
if numel(cmdpsr.PatternStr)==1
    operator = ['*', cmdpsr.PatternStr];
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

