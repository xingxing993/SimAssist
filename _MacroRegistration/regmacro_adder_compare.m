function sam = regmacro_adder_compare
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_compare');
sam.Pattern = '^[><=~]';
sam.Callback = @adder_compare;
sam.PromptMethod = {'=='  '~='  '<'  '<='  '>='  '>'};
end

function [actrec, success] =adder_compare(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('RelationalOperator');
opsym = regexp(cmdstr, '^[><=~]+', 'match', 'once');
if ~ismember(opsym, {'=='  '~='  '<'  '<='  '>='  '>'})
    return;
end
option1.AutoDataType = false; % disable auto-datatype coz output always boolean
[actrec2, block] = btobj.AddBlock('RelationalOperator','Operator', opsym, option1);
actrec.Merge(actrec2);
% add second operand if necessary
optstr = regexprep(cmdstr, '^[><=~]+', '');
if isempty(optstr)
    srchdls = saFindSystem(gcs,'line_sender');
    if ~isempty(srchdls)
        actrec.MultiAutoLine(srchdls, block);
    end
else
    btobjcnst = console.MapTo('Constant');
    pts = get_param(block, 'PortHandles');
    option2.PropagateString = false;
    actrec2 = btobjcnst.AddBlockToPort(pts.Inport(2), option2, 'Value', optstr);
    actrec.Merge(actrec2);
end
success = true;
end