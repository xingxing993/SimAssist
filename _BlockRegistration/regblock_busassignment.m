function sabt = regblock_busassignment
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('BusAssignment');
sabt.RoutineMethod = 'majorprop_str_num';
sabt.RoutinePattern = '^(busassign|busassignment)';

sabt.MajorProperty = 'Name';
sabt.BlockSize = [100, 120];

sabt.PropagateUpstreamStringMethod = @propagate_upstream;
sabt.PropagateDownstreamStringMethod = @propagate_downstream;
sabt.InportStringMethod = @inport_string_busassignement;

end


function thestr = inport_string_busassignement(pthdl, appdata)
ptnum = get_param(pthdl, 'PortNumber');
parblk = get_param(pthdl, 'Parent');
pttyp = get_param(pthdl, 'PortType');
sigs=regexp(get_param(parblk,'AssignedSignals'),',','split');
if ptnum>1
    thestr=sigs{ptnum-1};
else
    pts = get_param(parblk, 'PortHandles');
    thestr = appdata.Console.GetDownstreamString(pts.Outport(1));
end
end


function actrec = propagate_upstream(blkhdl, instr)
actrec = saRecorder;
sigstr = '';
sigs=regexp(get_param(blkhdl,'AssignedSignals'),',','split');
for i=2:numel(instr)
    if ~isempty(instr{i})
        sigs{i-1} = instr{i};
    end
end
sigstr = sprintf('%s,',sigs{:}); sigstr(end)='';
actrec.SetParam(blkhdl, 'AssignedSignals', sigstr);
end

function actrec = propagate_downstream(blkhdl)
actrec = saRecorder;
bussigs = saBusTraceForward(blkhdl);
if numel(bussigs)<1
    return;
else
    sigstr = sprintf('%s,',bussigs{:}); sigstr(end)='';
    actrec.SetParam(blkhdl, 'AssignedSignals', sigstr);
end
end
