function sam = regmacro_script_strrep
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('setter_strrep');
sam.Pattern = '^.+=>.*';
sam.Callback = @setter_strrep;
sam.Priority = 2;

end


function [actrec, success] =setter_strrep(cmdstr, console)
actrec=saRecorder;success = false;
regtmp = regexp(cmdstr, '^(.+)=>(.*)','once','tokens');
[oldstr, newstr] = regtmp{:};
objhdls = saFindSystem(gcs);
for i=1:numel(objhdls)
    saobj = console.MapTo(objhdls(i));
    actrec.Merge(saobj.ReplaceStr(objhdls(i), oldstr, newstr));
end
success = true;
end