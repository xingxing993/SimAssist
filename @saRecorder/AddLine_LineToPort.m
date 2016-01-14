function AddLine_LineToPort(obj, srchdl, dsthdl, overlap_offset)
% srchdl : line handle (connected)
% dsthdl : inport
if nargin<4
    overlap_offset = [0, 0];
end
dstpos = get_param(dsthdl,'Position');
% offset by -10 to create horizontal segment before inport,
% in future the offset may be calculated dynamically
points_layout = saLineRouteLineToDst(srchdl, dstpos, [overlap_offset+[-10,0]]);
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
newln = obj.AddLine(parsys, round(points_layout));
% restore line state
if ~isempty(lnname)
    set_param(newln, 'Name', lnname);
    if srcpt>0
        set_param(srcpt,'MustResolveToSignalObject',resolveflg);
    end
end
end
