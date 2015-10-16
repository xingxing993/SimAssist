function sam = regmacro_script_dislink
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('setter_dislink');
sam.Pattern = '^(dislink)';
sam.Callback = @setter_dislink;

end

function [actrec, success] =setter_dislink(cmdstr, console)
actrec=saRecorder;success = false;
objs1=saFindSystem(gcs, 'block',[],'BlockType','SubSystem');
objs2=saFindSystem(gcs, 'block',[],'BlockType','S-Function');
objs=[objs1;objs2];
for i=1:numel(objs)
    set_param(objs(i),'LinkStatus','inactive');
end
success = true;
end