function sam = regmacro_adder_trigger
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_trigger');
sam.Pattern = '^trig|trigger';
sam.Callback = @adder_trigger;

end

function [actrec, success] =adder_trigger(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('TriggerPort');
optstr=strtrim(regexprep(cmdstr,'^trig(ger)?\s*','','once'));
if ~isempty(optstr)
    optstr = strtrim(optstr);
    switch optstr
        case 'fc' %function-call
            trigtype = 'function-call';
        case 'r' %rising
            trigtype = 'rising';
        case 'f' %falling
            trigtype = 'falling';
        case 'e' %either
            trigtype = 'either';
        otherwise
            success = false; return;
    end
    pvpair = {'TriggerType', trigtype};
else
    pvpair = {};
end
actrec + btobj.RunRoutine('nooptstr', pvpair);
success = true;
end