function AutoLine(obj, srchdl, dsthdl, overlap_offset, varargin)
% wrapper function for line connection between two objects
% (line, port, block)
if nargin<4
    overlap_offset = [0, 0];
end
% input parameter parse and redefinition
srctyp = get_param(srchdl, 'type');
dsttyp = get_param(dsthdl, 'type');
if strcmp(srctyp, 'block')
    srcblkpts = get_param(srchdl, 'PortHandles');
    ptline = get_param(srcblkpts.Outport(1),'Line');
    if ptline>0
        srchdl = ptline; srctyp = 'line';
    else
        srchdl = srcblkpts.Outport(1); srctyp = 'port';
    end
end
if strcmp(dsttyp, 'block')
    dstblkpts= get_param(dsthdl, 'PortHandles');
    ptline = get_param(dstblkpts.Inport(1),'Line');
    if ptline<0
        dsthdl = dstblkpts.Inport(1); dsttyp = 'port';
    else
        return;
    end
end
if strcmp(srctyp,'line')
    if strcmp(get_param(srchdl, 'Connected'),'on')
        srcindex = 2;
    else
        srcindex = 3;
    end
else
    srcindex = 1;
end
if strcmp(dsttyp,'port')
    dstindex = 2;
else
    dstindex = 1;
end
switch srcindex
    case 1
        if dstindex == 1
            obj.AddLine_PortToNoSrcLine(srchdl, dsthdl);
        else
            obj.AddLine_PortToPort(srchdl, dsthdl);
        end
    case 2
        if dstindex == 1
            obj.AddLine_LineToNoSrcLine(srchdl, dsthdl, overlap_offset);
        else
            obj.AddLine_LineToPort(srchdl, dsthdl, overlap_offset);
        end
    case 3
        if dstindex == 1
            obj.AddLine_NoDstLineToNoSrcLine(srchdl, dsthdl);
        else
            obj.AddLine_NoDstLineToPort(srchdl, dsthdl);
        end
    otherwise
end
end