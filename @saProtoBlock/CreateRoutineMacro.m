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

rtmethod = obj.RoutineMethod;
if isa(rtmethod, 'function_handle')
    sam.Callback = rtmethod;
else %isstr
    fcn = str2func(['Routines.', rtmethod]);
    sam.Callback = @(cmdstr) feval(fcn, obj, cmdstr, pattern);
end
if ~isempty(obj.RoutinePrompts)
    sam.PromptMethod = obj.RoutinePrompts;
end
if ~isempty(obj.RoutinePriority)
    sam.Priority = obj.RoutinePriority; %promote priority
end
end