function AddLine_NoDstLineToPort(obj, srchdl, dsthdl)
% srchdl : line handle with destination disconnected
% dsthdl : inport
parsys = get_param(srchdl, 'Parent');
srcpos = get_param(srchdl, 'Points'); srcpos = srcpos(end,:);
dstpos = get_param(dsthdl, 'Position');
lnpoints = [srcpos;...
    round((srcpos(1)+dstpos(1))/2), srcpos(2);...
    round((srcpos(1)+dstpos(1))/2), dstpos(2);...
    dstpos];
obj.AddLine(parsys, lnpoints);
end