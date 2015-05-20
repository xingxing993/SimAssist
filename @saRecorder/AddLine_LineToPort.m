function AddLine_LineToPort(obj, srchdl, dsthdl, overlap_offset)
% srchdl : line handle (connected)
% dsthdl : inport
if nargin<4
    overlap_offset = [0, 0];
end
dstpos = get_param(dsthdl,'Position');
% offset by -10 to create horizontal segment before inport,
% in future the offset may be calculated dynamically
points_layout = get_line_layout(srchdl, dstpos, [overlap_offset+[-10,0]]);
parsys = get_param(srchdl,'Parent');
obj.AddLine(parsys, round(points_layout));
end