function sabt = regblock_enableport
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('EnablePort');

sabt.RoutineMethod = 'majorprop_value';
sabt.RoutinePattern = '^(en|enable)';
sabt.RoutinePriority = 40;

sabt.PropagateUpstreamStringMethod = @enpropupstream;

sabt.MajorProperty = 'Name';

sabt.BlockSize = [20, 20];
end

function actrec = enpropupstream(blkhdl, ~, console)
actrec = saRecorder;
parsys = get_param(blkhdl, 'Parent');
pts = get_param(parsys,'PortHandles');
thestr = console.GetUpstreamString(pts.Enable);
actrec.SetParam(blkhdl, 'Name', thestr);
end