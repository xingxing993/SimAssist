function sam = regmacro_script_autoline
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_autoline');
sam.Pattern = '^line';
sam.Callback = @script_autoline;

end

function [actrec, success] =script_autoline(cmdstr, console)
actrec=saRecorder;success = false;

srchdls = saFindSystem(gcs,'line_sender');
dsthdls = saFindSystem(gcs, 'line_receiver');
actrec.MultiAutoLine(srchdls, dsthdls);

success = true;
end