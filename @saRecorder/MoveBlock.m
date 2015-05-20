function MoveBlock(obj, blkhdl, vec, moveline)
if nargin<4
    moveline = false;
end
% move block
pos = get_param(blkhdl, 'Position');
newpos = [pos + [vec, vec]];
obj.SetParam(blkhdl, 'Position', newpos);
dx = vec(1);dy = vec(2);

if moveline

end

end