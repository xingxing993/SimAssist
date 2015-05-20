function sabt = regblock_busassignment
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('BusAssignment');
sabt.RoutineType = 'value_num';
sabt.RoutinePattern = '^busassignment';

sabt.InportStringMethod = @inport_string_busassignement;

end


function thestr = inport_string_busassignement(pthdl)
ptnum = get_param(pthdl, 'PortNumber');
parblk = get_param(pthdl, 'Parent');
pttyp = get_param(pthdl, 'PortType');
sigs=regexp(get_param(parblk,'AssignedSignals'),',','split');
if ptnum>1
    thestr=sigs{ptnum-1};
else
    thestr = get_param(parblk,'Name');
end
end