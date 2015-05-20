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
    opt = cmdstr(n:end);
end

blks=saFindSystem(gcs, 'block');
for i=1:numel(blks)
    btobj = console.MapTo(blks(i));
    actrec = btobj.SetProperty(blks(i), opt, nthprop);
end
success = true;
end