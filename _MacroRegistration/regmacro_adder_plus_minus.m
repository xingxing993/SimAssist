function sam = regmacro_adder_plus_minus
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_plus_minus');
sam.Pattern = '^[+-]';
sam.Callback = @adder_plus_minus;

end


function [actrec, success] =adder_plus_minus(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('Sum');
srchdls = saFindSystem(gcs,'line_sender');
operator = regexp(cmdstr,'^[+-]+', 'match','once'); 
operand = strtrim(regexprep(cmdstr,'^[+-]+\s*',''));
if numel(operator)==1
    operator = ['+', operator];
end
[actrec2, block] = btobj.AddBlock('Inputs', operator);
actrec.Merge(actrec2);
if isempty(srchdls)
    if ~isempty(operand) %add 2nd operand
        btobjcnst = console.MapTo('Constant');
        pts = get_param(block, 'PortHandles');
        option.PropagateString = false;
        actrec2 = btobjcnst.AddBlockToPort(pts.Inport(2), option, ...
            'Value', operand);
        actrec.Merge(actrec2);
    end
else
    actrec.MultiAutoLine(srchdls, block);
end

success = true;
end