function sabt = regblock_math
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Math');

sabt.RoutineMethod = @routine_math;
sabt.RoutinePattern = '^(exp|log|log10|square|sqrt|reciprocal|pow|rem|mod)';

sabt.BlockSize = [25, 25];

sabt.MajorProperty = 'Operator';
sabt.RollPropertyMethod = -1;
end

function [actrec, success] = routine_math(cmdstr, console)
btobj = console.MapTo('Math');
%parse input command
cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);
[actrec, success] = Routines.num_only(btobj, cmdpsr.OptionStr, '', 'Operator', cmdpsr.PatternStr);
end