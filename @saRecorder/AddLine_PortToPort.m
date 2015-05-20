function AddLine_PortToPort(obj, srchdl, dsthdl)
% srchdl : outport handle
% dsthdl : inport handle
parsys = get_param(get_param(srchdl, 'Parent'),'Parent');
obj.AddLine(parsys, srchdl, dsthdl);
end