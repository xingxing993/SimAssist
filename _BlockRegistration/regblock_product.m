function sabt = regblock_product
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Product');

parsabt = regblock_sum;
sabt.Inherit(parsabt);

sabt.RoutinePattern = '^[*/]+';
sabt.RoutineMethod = @routine_multiply_divide;

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
[operand, bclean] = cmdpsr.ParseSingleValue;
if ~bclean [actrec, success]=deal(saRecorder, false); return; end

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

