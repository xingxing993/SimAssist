function sam = regmacro_opsym_ampersand
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('opsym_ampersand');
sam.Pattern = '&';
sam.Callback = @opsym_ampersand;
sam.Priority = 1; % & operator shall first be tested
end

function [actrec, success] = opsym_ampersand(cmdstr, console)
% test & joint of multiple commands
actrec = saRecorder; success = false;
multicmdstrs = strtrim(regexp(cmdstr, '&', 'split'));
if numel(multicmdstrs)>1
    for i=1:numel(multicmdstrs)
        actrec + console.RunCommand(strtrim(multicmdstrs{i}));
    end
end
if ~isempty(actrec)
    success = true;
end
end