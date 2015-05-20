function sam = regmacro_script_breaklink
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('setter_breaklink');
sam.Pattern = '^(brk|break)';
sam.Callback = @setter_breaklink;

end

function [actrec, success] =setter_breaklink(cmdstr, console)
actrec=saRecorder;success = false;
objs1=saFindSystem(gcs, 'block',[],'BlockType','SubSystem');
objs2=saFindSystem(gcs, 'block',[],'BlockType','S-Function');
objs=[objs1;objs2];
for i=1:numel(objs)
    set_param(objs(i),'LinkStatus','none');
end
success = true;
end