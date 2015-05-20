function sam = regmacro_script_datatype
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('setter_datatype');
sam.Pattern = '^(single|sgl|double|dbl|boolean|bool|uint8|u8|uint16|u16|uint32|u32|int8|i8|int16|i16|int32|i32)';
sam.Callback = @setter_datatype;
end

function [actrec, success] =setter_datatype(cmdstr, console)
actrec=saRecorder;success = false;
dt = strtrim(cmdstr);
dt = saStandardDataTypeStr(dt);
if ~isempty(dt)
    tgtobjs = saFindSystem(gcs, 'block');
    for i=1:numel(tgtobjs)
        actrec + console.MapTo(tgtobjs(i)).SetDataType(tgtobjs(i), dt);
    end
end
success = true;
end