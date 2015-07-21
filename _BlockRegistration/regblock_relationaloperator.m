function sabt = regblock_relationaloperator
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('RelationalOperator');

sabt.RoutinePattern = '^[><=~]+';
sabt.RoutineMethod = @routine_compare;
sabt.RoutinePrompts = {'=='  '~='  '<'  '<='  '>='  '>'};



sabt.MajorProperty = 'Operator';
sabt.RollPropertyMethod = -1;

sabt.BlockPreferOption.AutoDataType = false;

sabt.BlockSize = [25, 70];

sabt.AutoSizeMethod = []; % no need for auto size
sabt.DataTypeMethod = [];

end


function [actrec, success] = routine_compare(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('RelationalOperator');
cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);
if ~ismember(cmdpsr.PatternStr, {'=='  '~='  '<'  '<='  '>='  '>'})
    return;
end
option1.AutoDataType = false; % disable auto-datatype coz output always boolean
[actrec2, block] = btobj.AddBlock('RelationalOperator','Operator', cmdpsr.PatternStr, option1); actrec.Merge(actrec2);
% add second operand if necessary
if isempty(cmdpsr.OptionStr)
    srchdls = saFindSystem(gcs,'line_sender');
    if ~isempty(srchdls)
        actrec.MultiAutoLine(srchdls, block);
    end
else
    btobjcnst = console.MapTo('Constant');
    pts = get_param(block, 'PortHandles');
    option2.PropagateString = false;
    actrec +  btobjcnst.AddBlockToPort(pts.Inport(2), option2, 'Value', cmdpsr.OptionStr); 
end
success = true;
end