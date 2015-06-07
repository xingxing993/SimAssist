function sam = regmacro_adder_math
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_math');
sam.Pattern = '^(exp|log|log10|square|sqrt|reciprocal|pow|rem|mod)';
sam.Callback = @adder_math;
end

function [actrec, success] =adder_math(cmdstr, console)
btobj = console.MapTo('Math');
success = false;
regpattern = '^(exp|log|log10|square|sqrt|reciprocal|pow|rem|mod)\s*';
regtmp = regexp(cmdstr, regpattern, 'tokens','once');
opsym=regtmp{1};
optstr = regexprep(cmdstr, regpattern, '','once');
if isempty(optstr)
    [actrec, success] = btobj.RunRoutine(optstr, {'Operator', opsym});
end
end