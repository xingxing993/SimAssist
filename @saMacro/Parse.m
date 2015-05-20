function varargout = Parse(obj, cmdstr, console)
if isempty(obj.ParseMethod)
    varargout{1} = cmdstr;
else
    if isa(obj.ParseMethod, 'function_handle')
        ni = nargin(obj.ParseMethod);
        args = {cmdstr, console};
        [varargout{1:nargout}] = obj.ParseMethod(args{1:ni});
    else
        varargout{1} = cmdstr;
    end
end
end