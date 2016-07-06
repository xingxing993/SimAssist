function sam = regmacro_script_autoline
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_autoline');
sam.Pattern = '^autoline';
sam.Callback = @script_autoline;

end

function [actrec, success] =script_autoline(cmdstr, console)
actrec=saRecorder;success = false;
% name based connection
% first priority: unconnected ports and lines
dsthdls = saFindSystem(gcs,'line_receiver');
if isempty(dsthdls)
    return;
else
    dstinfo(numel(dsthdls)) = struct('handle',[],'name',[]);
    for i=1:numel(dsthdls)
        dstinfo(i).handle = dsthdls(i);
        dstinfo(i).name = console.GetDownstreamString(dsthdls(i));
    end
end
srchdls = [saFindSystem(gcs,'outport_unconnected');saFindSystem(gcs,'line_nodst')];
if ~isempty(srchdls)
    srcinfo(numel(srchdls)) = struct('handle',[],'name',[]);
    for i=1:numel(srchdls)
        srcinfo(i).handle = srchdls(i);
        srcinfo(i).name = console.GetUpstreamString(srchdls(i));
    end
end
if exist('srcinfo','var')
    [dummy,ia,ib] = intersect({srcinfo.name}, {dstinfo.name});
    lnsrc = [srcinfo(ia).handle]';
    lndst = [dstinfo(ib).handle]';
    for i=1:numel(lnsrc)
        actrec.AutoLine(lnsrc(i), lndst(i));
    end
    dstinfo = dstinfo(setdiff(1:numel(dstinfo), ib)); % remove from destination list
end
% second priority: already has goto
btfrom = console.MapTo('From');
for i=1:numel(dstinfo)
    goto = find_system(gcs, 'FollowLinks','on','LookUnderMasks','on','FindAll', 'on', 'SearchDepth',1,'BlockType','Goto','GotoTag',dstinfo(i).name);
    if ~isempty(goto)
        actrec + btfrom.AddBlockToPort(dstinfo(i).handle);
    end
end
% third: automatically select from BusSelector

success = true;
end