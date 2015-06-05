function sam = CreateRoutineMacro(obj)
pattern = obj.RoutinePattern;
if isempty(pattern)
    sam = []; return;
end
name = ['#',obj.MapKey];

sam = saMacro(name);
sam.Type = 'Routine';
if pattern(1)~='^'
    sam.Pattern = ['^', pattern];
else
    sam.Pattern = pattern;
end
switch obj.RoutineType
    case 'nooptstr'
        sam.Callback = @(cmdstr)block_routine_nooptstr(cmdstr, pattern, obj);
    case {'value_num', 'value_only', 'multiprop'}
        sam.Callback = @(cmdstr)block_routine_generic(cmdstr, pattern, obj);
    case 'dynamicinport'
        sam.Callback = @(cmdstr)block_routine_dynamicinport(cmdstr, pattern, obj);    
    otherwise
        sam.Callback = [];
end
sam.Priority = obj.RoutinePriority; %promote priority
end

function [actrec, success] = block_routine_nooptstr(cmdstr, pattern, btobj)
optstr = regexprep(cmdstr, [pattern, '\s*'], '','once');
if ~isempty(optstr)
    actrec = saRecorder; success = false;
else
    [actrec, success] = btobj.RunRoutine;
end
end


function [actrec, success] = block_routine_generic(cmdstr, pattern, btobj)
optstr = regexprep(cmdstr, [pattern, '\s*'], '','once');
[actrec, success] = btobj.RunRoutine(optstr);
end

function [actrec, success] = block_routine_dynamicinport(cmdstr, pattern, btobj)
optstr = regexprep(cmdstr, [pattern, '\s*'], '','once');
[actrec, success] = btobj.RunRoutine(optstr, btobj.RoutinePara.InportProperty);
end