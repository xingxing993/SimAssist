function AddLine_PortToNoSrcLine(obj, srchdl, dsthdl)
% srchdl : outport handle
% dsthdl : line handle with source disconnected
parsys = get_param(dsthdl, 'Parent');
srcpos = get_param(srchdl, 'Position');
dstpos = get_param(dsthdl, 'Points');
dstpos = dstpos(1,:);
lnpoints = [srcpos;...
    round((srcpos(1)+dstpos(1))/2), srcpos(2);...
    round((srcpos(1)+dstpos(1))/2), dstpos(2);...
    dstpos];
obj.AddLine(parsys, lnpoints);
end