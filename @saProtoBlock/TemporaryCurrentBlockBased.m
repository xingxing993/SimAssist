function varargout = TemporaryCurrentBlockBased(obj, varargin)
if nargout>0 % varargin should be {blkhdl} in this condition
    if isequal(obj.AutoSizeMethod, -1)
        info.LayoutSize = obj.LayoutSize;
        % modify default port spacing
        ps = gcps(varargin{1});
        if ps>0
            obj.LayoutSize.PortSpacing = ps;
        end
    end
    varargout = {info};
else % varargin should be structure to be restored
    stru = varargin{1};
    flds = fieldnames(stru);
    for i=1:numel(flds)
        obj.(flds{i}) = stru.(flds{i});
    end
end

end


function ps = gcps(blkhdl) % get current port spacing
ptcnt = get_param(blkhdl, 'Ports');
lns = get_param(blkhdl, 'LineHandles');
blkpos = get_param(blkhdl, 'Position');
ht = blkpos(4)-blkpos(2);
ps = 0;
if ptcnt(1)>ptcnt(2)
    if sum(lns.Inport>0)>1
        ps = ceil(ht/ptcnt(1));
    end
elseif ptcnt(1)<ptcnt(2)
    if sum(lns.Outport>0)>1
        ps = ceil(ht/ptcnt(2));
    end
else
    if sum(lns.Outport>0) > sum(lns.Inport>0)
        ps = ceil(ht/ptcnt(2));
    else
        ps = ceil(ht/ptcnt(1));
    end
end
end