function tf = Check(obj, blkhdl)
tf = false;
if ~isa(obj.CheckMethod, 'function_handle')
    return;
end
if isstr(blkhdl)
    try
        blkhdl = get_param(blkhdl, 'Handle');
    catch
        return;
    end
end
tf = obj.CheckMethod(blkhdl);
end