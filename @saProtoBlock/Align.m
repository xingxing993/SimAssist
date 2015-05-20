function actrec = Align(obj, blkhdl, direction)
actrec = saRecorder;
if nargin<3
    direction = '[]';
end
if isempty(obj.AlignMethod)
    return;
else
    if isequal(obj.AlignMethod, -1)
        actrec = layout_around_block(blkhdl, direction);
    elseif isa(obj.AlignMethod, 'function_handle')
        nn = nargout(obj.AlignMethod);
        ni = nargin(obj.AlignMethod);
        argsin = {blkhdl, obj.LayoutSize, obj};
        if nn~=0 %if mandatory output exist, must be saRecorder
            actrec.Merge(obj.AlignMethod(argsin{1:ni}));
        else
            obj.AlignMethod(argsin{1:ni});
        end
    else
    end
end
end

function actrec = layout_around_block(blkhdl, direction)
if nargin<2
    direction = '[]';
end
actrec = saRecorder;
lns = get_param(blkhdl, 'LineHandles');
if any(direction=='[')
    for i=1:numel(lns.Inport)
        if lns.Inport(i)>0
            actrec.NeatenLine(lns.Inport(i), 'd2s+');
        end
    end
end
if any(direction==']')
    for i=1:numel(lns.Outport)
        if lns.Outport(i)>0
            actrec.NeatenLine(lns.Outport(i), 's2d+');
        end
    end
end
end


