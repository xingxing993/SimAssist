function actrec = Clean(obj, blkhdl, varargin)
actrec = saRecorder;
if isempty(obj.CleanMethod)
    return;
else
    cleanmethod = obj.CleanMethod;
    % customized clean process
    if isequal(cleanmethod, -1)
    elseif isa(cleanmethod, 'function_handle')
        nn = nargout(cleanmethod);
        ni = nargin(cleanmethod);
        argsin = {blkhdl, obj.Console, varargin{:}};
        if nn~=0 %if mandatory output exist, must be saRecorder
            actrec.Merge(cleanmethod(argsin{1:ni}));
        else
            cleanmethod(argsin{1:ni});
        end
    else
    end
end
end