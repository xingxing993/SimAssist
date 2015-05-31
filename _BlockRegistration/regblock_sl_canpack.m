function sabt = regblock_sl_canpack
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('canmsglib/CAN Pack');

sabt.InportStringMethod = @inport_string_canpack;

end


function thestr = inport_string_canpack(pthdl)
ptnum = get_param(pthdl, 'PortNumber');
parblk = get_param(pthdl, 'Parent');
mskwsvars = get_param(parblk,'MaskWSVariables');
portvar = mskwsvars(strcmp({mskwsvars.Name}, 'port')).Value; %find the "port" variable used to draw the outport name
%the first one is for inport, 2:end for outport
thestr = portvar(ptnum).label;
end