function actrec = PropagateDownstreamString(obj, blkhdl)
actrec = saRecorder;
down_prpg_method = obj.PropagateDownstreamStringMethod;
if isempty(down_prpg_method)
    return;
end

console = obj.Console;
if isstruct(down_prpg_method) % struct: StringPortNum, Method
    pts = get_param(blkhdl, 'PortHandles');
    blkostr = console.GetDownstreamString(pts.Outport(down_prpg_method.StringPortNum));
    down_prpg_method = down_prpg_method.Method;
else
    blkostr = console.GetDownstreamString(blkhdl);
end

if isa(down_prpg_method, 'function_handle')
    nn = nargout(down_prpg_method);
    if nn~=0 %if mandatory output exist, must be saRecorder
        actrec.Merge(down_prpg_method(blkhdl, blkostr));
    else
        down_prpg_method(blkhdl, blkostr);
    end
elseif isstr(down_prpg_method) && ~isempty(blkostr)
    if iscell(blkostr)
        blkostr = blkostr{1};
    end
    actrec.SetParam(blkhdl, down_prpg_method, blkostr);
else
end
% actrec + obj.AutoSize(blkhdl);