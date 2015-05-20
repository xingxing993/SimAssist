function varargout = Dispatch(obj, recvr, event, varargin)

btobj = obj.MapTo(recvr);

if nargin>2 && (ismethod(btobj, event) || isprop(btobj, event)) % if given function to call
    [varargout{1:nargout}] = btobj.(event)(varargin{:});
else
    varargout{1} = btobj;
end
end