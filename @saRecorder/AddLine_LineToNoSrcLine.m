function AddLine_LineToNoSrcLine(obj, srchdl, dsthdl, overlap_offset)
% srchdl : line handle (connected)
% dsthdl : line handle with source disconnected
if nargin<4
    overlap_offset = [0, 0];
end
dstpos = get_param(dsthdl,'Points');
points_layout = get_line_layout(srchdl, dstpos(1,:), overlap_offset);
parsys = get_param(srchdl,'Parent');
% backup line info to restore change of state after add_line
lnname = regexprep(get_param(srchdl, 'Name'), '[<>]', '');
srcpt = get_param(srchdl,'SrcPortHandle');
if srcpt>0
    resolveflg = get_param(srcpt,'MustResolveToSignalObject');
else
    resolveflg = 'off';
end
% add line
obj.AddLine(parsys, round(points_layout));
% restore line state
if ~isempty(lnname)
    set_param(newln, 'Name', lnname);
    if srcpt>0
        set_param(srcpt,'MustResolveToSignalObject',resolveflg);
    end
end

end