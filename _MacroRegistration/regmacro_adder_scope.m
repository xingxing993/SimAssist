function sam = regmacro_adder_scope
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_scope');
sam.Pattern = '^scope';
sam.Callback = @adder_scope;

end

function [actrec, success] =adder_scope(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('Scope');
regtmp = regexp(cmdstr, '^scope(s)?\s*(\d*)', 'tokens','once');
optstr = strtrim(regexprep(cmdstr, '^scopes?\s*', ''));
if ~isempty(regtmp{1}) % if use single port scope
    actrec + btobj.RunRoutine('value_num', optstr);
else
    actrec + btobj.RunRoutine('dynamicinport', optstr, 'NumInputPorts');
end
success = true;
end