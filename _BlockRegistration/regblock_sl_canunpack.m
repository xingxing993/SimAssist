function sabt = regblock_sl_canunpack
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('canmsglib/CAN Unpack');

sabt.OutportStringMethod = @outport_string_canunpack;

end


function thestr = outport_string_canunpack(pthdl)
ptnum = get_param(pthdl, 'PortNumber');
parblk = get_param(pthdl, 'Parent');
mskwsvars = get_param(parblk,'MaskWSVariables');
portvar = mskwsvars(strcmp({mskwsvars.Name}, 'port')).Value; %find the "port" variable used to draw the outport name
%the first one is for inport, 2:end for outport
thestr = portvar(1+ptnum).label;
end