function sam = regmacro_opsym_percent
% Registration of ??? macro in SimAssist

sam = saMacro('opsym_percent');
sam.Pattern = '^%';
sam.Callback = @opsym_percent;
sam.Priority = 1; % $ operator shall first be tested
end

function [actrec, success] = opsym_percent(cmdstr, console)
actrec = saRecorder; success = false;
if isempty(optstr)
    return;
end
cmdstr(1)='';
actrec + simassist_usermacro(cmdstr);
success = true;
end