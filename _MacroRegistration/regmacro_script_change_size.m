function sam = regmacro_script_change_size
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_change_size');
sam.Pattern = '^(short|long|narrow|wide)';
sam.Callback = @script_change_size;

end

function [actrec, success] =script_change_size(cmdstr, console)
actrec=saRecorder;success = false;
objhdls = saFindSystem(gcs,'block');
type = regexp(cmdstr,'^(short|long|narrow|wide)','match','once');
opt = regexprep(cmdstr,'^(short|long|narrow|wide)e?r?\s*','','once');
if isempty(opt)
    scale = 1.1;
else
    scale = str2double(opt);
    if isnan(scale) || ~scale
        success = false; return;
    end
end
for i=1:numel(objhdls)
    oldpos = get_param(objhdls(i),'Position');
    oldsz = oldpos(3:4)-oldpos(1:2);
    W0 = oldsz(1);   H0 = oldsz(2);
    dW = 0; dH = 0;
    switch type
        case 'long'
            dH = max(H0*scale-H0, 1);
        case 'short'
            dH = min(H0/scale-H0, -1);
        case 'narrow'
            dW = min(W0/scale-W0, -1);
        case 'wide'
            dW = max(W0*scale-W0, 1);
        otherwise
    end
    newpos = saRectifyPos(oldpos + round([-dW, -dH, dW, dH]/2));
    actrec.SetParam(objhdls(i), 'Position', newpos);
    % ## some times position change fails if delta value too small, the
    % following code segment intends to handle this situation
    retrymax = 8;
    for k=1:retrymax
        rdbkpos = get_param(objhdls(i), 'Position');
        if all(rdbkpos == oldpos)
            retrypos = saRectifyPos(oldpos+ 2^(k+1)*[-dW, -dH, dW, dH]);
            actrec.SetParam(objhdls(i), 'Position', retrypos);
        else
            break;
        end
    end
end
success = true;
end