function sam = regmacro_script_annotation
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_annotation');
sam.Pattern = '^anno';
sam.Callback = @script_annotation;

end

function [actrec, success] =script_annotation(cmdstr, console)
actrec=saRecorder;success = false;
optstr = strtrim(regexprep(cmdstr,'^anno\s*','', 'once'));
tgtobjs= saFindSystem(gcs, 'block');
if isempty(optstr)
    for i=1:numel(tgtobjs)
        actrec + console.MapTo(tgtobjs(i)).Annotate(tgtobjs(i));
    end
else %customize annotation
    for i=1:numel(tgtobjs)
        if strcmp(optstr, '-')
            actrec.SetParam(tgtobjs(i),'AttributesFormatString','');
        else
            actrec.SetParam(tgtobjs(i),'AttributesFormatString',optstr);
        end
    end
end
success = true;
end