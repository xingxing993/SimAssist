function sam = regmacro_opsym_percent
% Registration of ??? macro in SimAssist

sam = saMacro('opsym_percent');
sam.Pattern = '^%';
sam.Callback = @opsym_percent;
sam.Priority = 1; % $ operator shall first be tested
end

function [actrec, success] = opsym_percent(cmdstr, console)
actrec = saRecorder; success = false;
optstr = cmdstr(2:end);
otherpattern = ~isempty(strfind(optstr, '=>'))||~isempty(strfind(optstr, '>>'));
if isempty(optstr)||otherpattern
    return;
end
% actrec + simassist_usermacro(cmdstr);
fun_arg = regexp(optstr, ',|\s', 'split');
if exist(fun_arg{1}, 'file')
    if numel(fun_arg)>1
        arglist = sprintf('''%s'',',fun_arg{2:end}); arglist(end)='';
        evalin('base', sprintf('%s(%s);', fun_arg{1}, arglist));
    else
        evalin('base', fun_arg{1});
    end
    success = true;
end
end