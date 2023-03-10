function sam = regmacro_script_colorit
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_colorit');
sam.Pattern = '^[bf]?color';
sam.PromptMethod = {'bcolor','color','fcolor','color=='};
sam.Callback = @script_colorit;
sam.Priority = 19;
end

function [actrec, success] =script_colorit(cmdstr, console)
actrec=saRecorder;success = false;
rtsys = gcs;
if cmdstr(1)=='b'
    bg = true;
else
    bg = false;
end
optstr=strtrim(regexprep(cmdstr,'^[bf]?color\s*','','once'));
if ismember(optstr, {'same','=', '=='})
    optstr = mat2str(rand(1,3));
end
tgtblks = saFindSystem(rtsys, 'block');
for i=1:numel(tgtblks)
    if isempty(optstr)
        rgb=mat2str(rand(1,3));
    else
        rgb=optstr;
    end
    if bg
        rgb = {[], rgb};
    end
    btobj = console.MapTo(tgtblks(i));
    actrec + btobj.Color(tgtblks(i), rgb);
    broblks = btobj.GetBroBlocks(tgtblks(i));
    for k=1:numel(broblks)
        brobtobj = console.MapTo(broblks(k));
        actrec + brobtobj.Color(broblks(k), rgb);
    end
end
success = true;
end