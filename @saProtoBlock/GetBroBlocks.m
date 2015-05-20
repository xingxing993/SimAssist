function broblks = GetBroBlocks(obj, blkhdl, varargin)
if isempty(obj.GetBroMethod)
    broblks = [];
    return;
else
    if isequal(obj.GetBroMethod, -1)
        broblks = [];
    elseif isa(obj.GetBroMethod, 'function_handle')
        ni = nargin(obj.GetBroMethod);
        argsin = {blkhdl, obj};
        broblks = obj.GetBroMethod(argsin{1:ni});
    else
        broblks = [];
    end
end
end