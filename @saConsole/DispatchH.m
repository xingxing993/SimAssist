function varargout = DispatchH(obj, recvr, event, varargin)

btobj = obj.MapTo(recvr);

if nargin>2 && (ismethod(btobj, event) || isprop(btobj, event))% if given function to call
    % if given handle as receiver, pass it as the first argument
    if isnumeric(recvr)
        [varargout{1:nargout}] = btobj.(event)(recvr, varargin{:});
    else
        [varargout{1:nargout}] = btobj.(event)(varargin{:});
    end
else
    varargout{1} = btobj;
end
end