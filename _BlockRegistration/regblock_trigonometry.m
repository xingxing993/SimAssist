function sabt = regblock_trigonometry
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Trigonometry');

sabt.RoutineMethod = @routine_trigonometry;
sabt.RoutinePattern = '^(sinh|cosh|tanh|asinh|acosh|atanh|sincos|sin|cos|tan|asin|acos|atan)';


sabt.MajorProperty = 'Operator';
sabt.RollPropertyMethod = -1;
end

function [actrec, success] = routine_trigonometry(cmdstr, console)
btobj = console.MapTo('Trigonometry');
%parse input command
cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);
[actrec, success] = Routines.num_only(btobj, cmdpsr.OptionStr, '', 'Operator', cmdpsr.PatternStr);
end