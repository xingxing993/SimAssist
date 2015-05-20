function sam = regmacro_script_simulink_to_motohawk
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_simulink_to_motohawk');
sam.Pattern = '^s2m';
sam.Callback = @script_simulink_to_motohawk;

end

function [actrec, success] =script_simulink_to_motohawk(cmdstr, console)
actrec=saRecorder;success = false;
objhdls = saFindSystem(gcs, 'block');
opt = regexprep(cmdstr, '^s2m\s*', '');
if ~isempty(objhdls)
    actrec.Merge(s2m_wrapper(gcs,opt,false,'Selected','on'));
else
    actrec.Merge(s2m_wrapper(gcs,opt,false));
end
success = true;
end