function sam = regmacro_script_clean
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_clean');
sam.Pattern = '^clean';
sam.Callback = @script_clean;

end

function [actrec, success] =script_clean(cmdstr, console)
actrec=saRecorder;success = false;
% 1. clean unconnected lines
lns = saFindSystem(gcs, 'line_unconnected');
actrec.DeleteLine(lns);
% 2. clean unconnected blocks
blocks = saFindSystem(gcs, 'block');
for i=1:numel(blocks)
    lns = get_param(blocks(i),'LineHandles');
    flds = fieldnames(lns);
    for kf = 1:numel(flds)
        tmplnhdls = lns.(flds{kf});
        if isempty(tmplnhdls)||all(tmplnhdls<0)
            haveline = false;
        else
            haveline = true; break;
        end
    end
    if ~haveline
        delete(blocks(i));
    end
end
% 3. Call clean method of blocks
blocks = saFindSystem(gcs, 'block'); % must find again
optstr = strtrim(regexprep(cmdstr, '^clean\s*', '' ,'once'));
for i=1:numel(blocks)
    btobj = console.MapTo(blocks(i));
    actrec + btobj.ArrangePort(blocks(i), optstr);
    actrec + btobj.Clean(blocks(i));
end
success = true;
end