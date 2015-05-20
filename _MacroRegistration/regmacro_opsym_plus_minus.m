function sam = regmacro_opsym_plus_minus
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('opsym_plus_minus');
sam.Pattern = '^[+-]';
sam.Callback = @opsym_plus_minus;
sam.Priority = 2; % operator shall first be tested
end


function [actrec, success] = opsym_plus_minus(cmdstr, console)
actrec=saRecorder;success = false;
operand = strtrim(cmdstr(2:end));
selblks = saFindSystem(gcs, 'block');
for i=1:numel(selblks)
    btobj = console.MapTo(selblks(i));
    if cmdstr(1)=='+' && ~isempty(btobj.PlusMethod)
        actrec + btobj.Plus(selblks(i), operand);
    else
        if isequal(cmdstr, '-') % note this special usage, '-' equivalent to 'clean'
            actrec + console.RunCommand('clean');
        elseif ~isempty(btobj.MinusMethod)
            actrec + btobj.Minus(selblks(i), operand);
        end
    end
end
if ~actrec.isempty
    success = true;
end
end