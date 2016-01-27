function actrec = AutoSize(obj, blkhdl)
actrec = saRecorder;
if isempty(obj.AutoSizeMethod)
    return;
else
    if isequal(obj.AutoSizeMethod, -1) % downwards extend based on port spacing
        actrec = resize_height(blkhdl, obj.LayoutSize);
    elseif isequal(obj.AutoSizeMethod, -2) % leftwards extend based on string of major property
        actrec = resize_leftwards(blkhdl, obj.LayoutSize, get_param(blkhdl, obj.GetMajorProperty(blkhdl)));
    elseif isequal(obj.AutoSizeMethod, -3) % rightwards extend based on string of major property
        actrec = resize_rightwards(blkhdl, obj.LayoutSize, get_param(blkhdl, obj.GetMajorProperty(blkhdl)));
    elseif isa(obj.AutoSizeMethod, 'function_handle')
        nn = nargout(obj.AutoSizeMethod);
        ni = nargin(obj.AutoSizeMethod);
        argsin = {blkhdl, obj.LayoutSize, obj};
        if nn~=0 %if mandatory output exist, must be saRecorder
            actrec.Merge(obj.AutoSizeMethod(argsin{1:ni}));
        else
            obj.AutoSizeMethod(argsin{1:ni});
        end
    else
    end
end
end


function actrec = resize_height(blkhdl, szlayout)
actrec = saRecorder;
ptcnt = get_param(blkhdl, 'Ports');
if ptcnt(1)<2 && ptcnt(2)<2
    return;
end
oldpos = get_param(blkhdl, 'Position');
h2 = szlayout.PortSpacing * max([ptcnt(1:2), 2]);
newpos = oldpos;
newpos(4) = newpos(2)+h2;
actrec.SetParam(blkhdl, 'Position', newpos);
end

function actrec = resize_leftwards(blkhdl, szlayout, majorpropval)
actrec = saRecorder;
oldpos = get_param(blkhdl, 'Position');
w2 = szlayout.CharWidth*(numel(majorpropval)+3);
newpos = oldpos;
newpos(1) = newpos(3)-w2;
actrec.SetParam(blkhdl, 'Position', saRectifyPos(newpos));
end

function actrec = resize_rightwards(blkhdl, szlayout, majorpropval)
actrec = saRecorder;
oldpos = get_param(blkhdl, 'Position');
w2 = szlayout.CharWidth*(numel(majorpropval)+3);
newpos = oldpos;
newpos(3) = newpos(1)+w2;
actrec.SetParam(blkhdl, 'Position', newpos);
end