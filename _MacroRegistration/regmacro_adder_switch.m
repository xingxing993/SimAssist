function sam = regmacro_adder_switch
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_switch');
sam.Pattern = '^(sw|switch)';
sam.Callback = @adder_switch;

end

function [actrec, success] =adder_switch(cmdstr, console)
btobj = console.MapTo('Switch');
optstr = regexprep(cmdstr, '^(sw|switch)\s*', '', 'once');
if ismember(optstr, {'1', '3'})
    btobj.ConnectPort = [str2double(optstr), 1];
else
    if isempty(optstr)||isequal(optstr,'2')
        btobj.ConnectPort(2)=0; % disable insert to line behavior
    else
        actrec = saRecorder;
        success = false;
        return;
    end
end
[actrec, success] = btobj.RunRoutine('nooptstr');
btobj.ConnectPort = [2, 1]; % RESTORE
end
