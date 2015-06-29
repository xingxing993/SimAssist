function sabt = regblock_rounding
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Rounding');

sabt.RoutinePattern = '^(floor|round|ceil|fix)';
sabt.RoutineMethod = @routine_rounding;

sabt.MajorProperty = 'Operator';
sabt.RollPropertyMethod = -1;
end

function [actrec, success] = routine_rounding(cmdstr, console)
btobj = console.MapTo('Rounding');
%parse input command
cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);
[actrec, success] = Routines.num_only(btobj, cmdpsr.OptionStr, '', 'Operator', cmdpsr.PatternStr);
end