function actrec = PropagateUpstreamString(obj, blkhdl)
actrec = saRecorder;
up_prpg_method = obj.PropagateUpstreamStringMethod;
if isempty(up_prpg_method)
    return;
end

console = obj.Console;
if isstruct(up_prpg_method) % struct: StringPortNum, Method
    pts = get_param(blkhdl, 'PortHandles');
    blkistr = console.GetUpstreamString(pts.Inport(up_prpg_method.StringPortNum));
    up_prpg_method = up_prpg_method.Method;
else
    blkistr = console.GetUpstreamString(blkhdl);
end

if isa(up_prpg_method, 'function_handle')
    nn = nargout(up_prpg_method);
    if nn~=0 %if mandatory output exist, must be saRecorder
        actrec.Merge(up_prpg_method(blkhdl, blkistr));
    else
        up_prpg_method(blkhdl, blkistr);
    end
elseif isstr(up_prpg_method) && ~isempty(blkistr)
    if iscell(blkistr)
        blkistr = blkistr{1};
    end
    actrec.SetParam(blkhdl, up_prpg_method, blkistr);
else
end
% actrec + obj.AutoSize(blkhdl);