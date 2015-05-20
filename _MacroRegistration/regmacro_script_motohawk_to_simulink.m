function sam = regmacro_script_motohawk_to_simulink
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_motohawk_to_simulink');
sam.Pattern = '^m2s';
sam.Callback = @script_motohawk_to_simulink;

end

function [actrec, success] =script_motohawk_to_simulink(cmdstr, console)
actrec=saRecorder;success = false;
objhdls=saFindSystem(gcs, 'block');
opt = regexprep(cmdstr, '^m2s\s*', '');
if ~isempty(objhdls)
    actrec.Merge(m2s_wrapper(gcs,opt,false,'Selected','on'));
else
    actrec.Merge(m2s_wrapper(gcs,opt,false));
end
success = true;
end