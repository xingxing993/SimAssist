function sam = regmacro_script_datacompare
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_datacompare');
sam.Pattern = '^datacompare';
sam.Callback = @script_datacompare;

end

function [actrec, success] =script_datacompare(cmdstr, console)
actrec=saRecorder;success = false;

if ~strcmpi(get_param(gcb,'BlockType'),'SubSystem')
    return;
end
opblks = find_system(gcb,'FollowLinks','on','LookUnderMasks','on','SearchDepth',1,'BlockType','Outport');
pts=get_param(gcb,'PortHandles');
pts = pts.Outport;
for i=1:numel(pts)
    if get_param(pts(i),'Line')~=-1
        continue;
    end
    ptpos=get_param(pts(i),'Position');
    signame = get_param(opblks{i},'Name');
    blk_inport = add_block(['built-in/Inport'], [gcs, '/', signame], 'MakeNameUnique', 'on', 'Position', [ptpos(1)+25,ptpos(2)+13,ptpos(1)+25+30,ptpos(2)+13+14]);
    blk_dtcnv = add_block(['built-in/DataTypeConversion'], [gcs, '/conv_', signame], 'MakeNameUnique', 'on', 'Position', [ptpos(1)+80,ptpos(2)+12,ptpos(1)+80+50,ptpos(2)+12+16], 'ShowName','off');
    blk_mux = add_block(['built-in/Mux'], [gcs, '/mux_', signame], 'MakeNameUnique', 'on', 'Position', [ptpos(1)+180,ptpos(2)-10,ptpos(1)+180+5,ptpos(2)-10+40], 'ShowName','off','DisplayOption','bar','Inputs','2');
    blk_scope = add_block(['built-in/Scope'], [gcs, '/Scope_', signame], 'MakeNameUnique', 'on', 'Position', [ptpos(1)+210,ptpos(2)-5,ptpos(1)+210+30,ptpos(2)-5+30], 'LimitDataPoints','off');
    pts_inport = get_param(blk_inport,'PortHandles');
    pts_dtcnv = get_param(blk_dtcnv,'PortHandles');
    pts_mux = get_param(blk_mux,'PortHandles');
    pts_scope = get_param(blk_scope,'PortHandles');
    add_line(gcs,pts(i),pts_mux.Inport(1),'autorouting','on');
    add_line(gcs,pts_inport.Outport(1),pts_dtcnv.Inport(1),'autorouting','on');
    add_line(gcs,pts_dtcnv.Outport(1),pts_mux.Inport(2),'autorouting','on');
    add_line(gcs,pts_mux.Outport(1),pts_scope.Inport(1),'autorouting','on');
end

success = true;
end