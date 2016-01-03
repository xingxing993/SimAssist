function sam = regmacro_script_magnetic
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_magnetic');
sam.Pattern = '^magnetic';
sam.Callback = @script_magnetic;

end

function [actrec, success] =script_magnetic(cmdstr, console)
actrec=saRecorder;success = false;
if ~strcmpi(get_param(gcbh,'BlockType'),'SubSystem')
    return;
end
sysblk = gcb; currsys = gcs;
pts=get_param(sysblk,'PortHandles');
opt = strrep(cmdstr,'magnetic','');
if isfield(console.SessionPara, 'ConnectSide')
    in_cnnt = console.SessionPara.ConnectSide(1);
    out_cnnt = console.SessionPara.ConnectSide(2);
else
    in_cnnt = true; out_cnnt = true;
end
if in_cnnt
    btfrom = console.MapTo('From');
    for i=1:numel(pts.Inport)
        if get_param(pts.Inport(i),'Line')>0
            continue;
        end
        subinpt = find_system(sysblk, 'FollowLinks','on','LookUnderMasks','on','FindAll', 'on', 'SearchDepth',1,'BlockType','Inport','Port',int2str(i));
        ptname = get_param(subinpt, 'Name');
        goto = find_system(currsys, 'FollowLinks','on','LookUnderMasks','on','FindAll', 'on', 'SearchDepth',1,'BlockType','Goto','GotoTag',ptname);
        if ~isempty(goto)
            actrec + btfrom.AddBlockToPort(pts.Inport(i));
        else
            inpt = find_system(currsys, 'FollowLinks','on','LookUnderMasks','on','FindAll', 'on', 'SearchDepth',1,'BlockType','Inport','Name',ptname);
            if ~isempty(inpt)
                actrec.AddLine(currsys, inpt, pts.Inport(i));
            end
        end
    end
end
if out_cnnt
    btgoto = console.MapTo('Goto');
    for i=1:numel(pts.Outport)
        if get_param(pts.Outport(i),'Line')>0
            continue;
        end
        suboutpt = find_system(sysblk, 'FollowLinks','on','LookUnderMasks','on','FindAll', 'on', 'SearchDepth',1,'BlockType','Outport','Port',int2str(i));
        ptname = get_param(suboutpt, 'Name');
        from = find_system(currsys, 'FollowLinks','on','LookUnderMasks','on','FindAll', 'on', 'SearchDepth',1,'BlockType','From','GotoTag',ptname);
        if ~isempty(from)
            actrec + btgoto.AddBlockToPort(pts.Outport(i));
        else
            outpt = find_system(currsys, 'FollowLinks','on','LookUnderMasks','on','FindAll', 'on', 'SearchDepth',1,'BlockType','Outport','Name',ptname);
            if ~isempty(outpt)
                optlns = get_param(outpt, 'LineHandles');
                if optlns.Inport<0
                    actrec.AddLine(currsys, pts.Outport(i), outpt);
                end
            end
        end
    end
end
success = true;
end