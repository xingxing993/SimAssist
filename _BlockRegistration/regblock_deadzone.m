function sabt = regblock_deadzone
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('DeadZone');

sabt.RoutineType = 'multiprop';
sabt.RoutinePattern = '^(dzone|dz|deadzone)';

sabt.MajorProperty = {'LowerValue', '_Lb';'UpperValue','_Ub'};
sabt.DictRenameMethod = {'UpperValue','LowerValue'};

sabt.PropagateUpstreamStringMethod = @set_string;
sabt.PropagateDownstreamStringMethod = @set_string;
sabt.InportStringMethod = @inport_string;

sabt.BlockPreferOption.Annotation = true;
sabt.AnnotationMethod = 'DeadZone: %<LowerValue> - %<UpperValue>';
end


function thestr = inport_string(pthdl, appdata)
ptnum = get_param(pthdl, 'PortNumber');
parblk = get_param(pthdl, 'Parent');
parpts = get_param(parblk, 'PortHandles');
outstr = appdata.Console.GetDownstreamString(parpts.Outport);
thestr = [outstr, 'Raw'];
end

function actrec = set_string(blkhdl, instr)
actrec = saRecorder;
actrec.SetParam(blkhdl, 'UpperValue', [instr, '_Ub']);
actrec.SetParam(blkhdl, 'LowerValue', [instr, '_Lb']);
end