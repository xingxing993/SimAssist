function sabt = regblock_saturate
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Saturate');
sabt.RoutineMethod = 'multiprop';
sabt.RoutinePattern = '^(sat|saturate)';


sabt.MajorProperty = {'UpperLimit','_Hi';'LowerLimit','_Lo'};
sabt.DictRenameMethod = {'UpperLimit','LowerLimit'};

sabt.PropagateUpstreamStringMethod = @set_string;
sabt.PropagateDownstreamStringMethod = @set_string;
sabt.InportStringMethod = @inport_string;
sabt.AnnotationMethod = 'Limit: %<LowerLimit> - %<UpperLimit>';

sabt.BlockSize = [30, 30];

sabt.BlockPreferOption.Annotation = true; % turn on annotation for this block type

sabt.DefaultDataType = 'Inherit: Same as input';

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
actrec.SetParam(blkhdl, 'UpperLimit', [instr, '_Hi']);
actrec.SetParam(blkhdl, 'LowerLimit', [instr, '_Lo']);
end