function sam = regmacro_script_majorprop
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('setter_majorprop');
sam.Pattern = '^[\\]';
sam.Callback = @setter_majorprop;

end


function [actrec, success] =setter_majorprop(cmdstr, console)
actrec=saRecorder;success = false;
n=1;
while cmdstr(n)=='\'
    n=n+1; %number of preceding \
end
nthprop = n-1;
if numel(cmdstr)<n
    opt='';
else
    optstr = cmdstr(n:end);
    opt = regexp(optstr, '\s+|,', 'split');
end

blks=saFindSystem(gcs, 'block');
for i=1:numel(blks)
    if iscellstr(opt)
        propval = opt{min(i, end)};
    else
        propval = opt;
    end
    btobj = console.MapTo(blks(i));
    if strcmp(btobj.MapKey, '#NO_MATCH#')
        dlgparas = fieldnames(get_param(blks(i), 'DialogParameters'));
        actrec.SetParam(blks(i), dlgparas{min(end, nthprop)}, propval);
    else
        actrec = btobj.SetProperty(blks(i), propval, nthprop);
    end
end
success = true;
end