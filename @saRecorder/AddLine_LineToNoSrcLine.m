function AddLine_LineToNoSrcLine(obj, srchdl, dsthdl, overlap_offset)
% srchdl : line handle (connected)
% dsthdl : line handle with source disconnected
if nargin<4
    overlap_offset = [0, 0];
end
dstpos = get_param(dsthdl,'Points');
points_layout = get_line_layout(srchdl, dstpos(1,:), overlap_offset);
parsys = get_param(srchdl,'Parent');
obj.AddLine(parsys, round(points_layout));
end