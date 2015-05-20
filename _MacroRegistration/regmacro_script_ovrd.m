function sam = regmacro_script_ovrd
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_ovrd');
sam.Pattern = '^ovrd';
sam.Callback = @script_ovrd;

end

function [actrec, success] =script_ovrd(cmdstr, console)
actrec=saRecorder;success = false;
rtsys = gcs;
optstr=strtrim(regexprep(cmdstr,'^ovrd\s*','','once'));
lns = saFindSystem(rtsys, 'line');
ucpts = saFindSystem(rtsys, 'outport_unconnected');
swobj = console.MapTo('Switch');
cnstobj = console.MapTo('Constant');
option.PropagateString = false;
option.AutoSize = true;
option.GetMarginByMouse = false;
for i=1:numel(lns)
    signame = console.GetUpstreamString(lns(i));
    [actrec2, swblk] = swobj.InsertBlockToLine(lns(i), [3, 1], option);
    actrec + actrec2;
    swpts = get_param(swblk, 'PortHandles');
    actrec + cnstobj.AddBlockToPort(swpts.Inport(1), option, 'Value', [signame, '_ovrdval']);
    actrec + cnstobj.AddBlockToPort(swpts.Inport(2), option, 'Value', [signame, '_ovrdflg'], 'OutDataTypeStr','boolean');
end
for i=1:numel(ucpts)
    signame = console.GetUpstreamString(ucpts(i));
    swobj.ConnectPort = [3, 1]; %temporarily change to 3rd inport first
    [actrec2, swblk] = swobj.AddBlockToPort(ucpts(i), option);
    actrec + actrec2;
    swobj.ConnectPort = [2, 1]; %restore
    swpts = get_param(swblk, 'PortHandles');
    actrec + cnstobj.AddBlockToPort(swpts.Inport(1), option, 'Value', [signame, '_ovrdval']);
    actrec + cnstobj.AddBlockToPort(swpts.Inport(2), option, 'Value', [signame, '_ovrdflg'], 'OutDataTypeStr','boolean');
end
% success = true;
end