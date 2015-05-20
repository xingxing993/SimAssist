function sam = regmacro_adder_logic
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_logic');
sam.Pattern = '^(and|or|not|xor|nor|nand)';
sam.Callback = @adder_logical;
end

function [actrec, success] =adder_logical(cmdstr, console)
btobj = console.MapTo('Logic');
regtmp = regexp(cmdstr, '^(and|or|not|xor|nor|nand)\s*', 'tokens','once');
opsym=regtmp{1};
optstr = regexprep(cmdstr, '^(and|or|not|xor|nor|nand)\s*', '','once');
pvpair = {'Operator', opsym};
[actrec, success] = btobj.RunRoutine(optstr, 'Inputs', pvpair);
end