function sam = regmacro_adder_minmax
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_minmax');
sam.Pattern = '^(min|max|mn|mx)';
sam.Callback = @adder_minmax;
end

function [actrec, success] =adder_minmax(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('MinMax');
regtmp = regexp(cmdstr, '^(min|max|mn|mx)\s*', 'tokens','once');
opsym=regtmp{1};
switch opsym
    case 'mn'
        opsym = 'Min';
    case 'mx'
        opsym = 'Max';
end
optstr = regexprep(cmdstr, '^(min|max|mn|mx)\s*', '','once');
pvpair = {'Function', opsym};
actrec + btobj.RunRoutine(optstr, 'Inputs', pvpair);
success = true;
end