function sam = regmacro_script_unname
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_unname');
sam.Pattern = '^unname';
sam.Callback = @script_unname;

end

function [actrec, success] =script_unname(cmdstr, console)
actrec=saRecorder;success = false;
lns=saFindSystem(gcs, 'line');
for i=1:numel(lns)
    actrec.SetParam(lns(i),'Name','');
end
success = true;
end