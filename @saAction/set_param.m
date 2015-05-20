function set_param(obj,varargin)
if isstr(varargin{1})
    obj.Handle = get_param(varargin{1},'Handle');
else
    obj.Handle = varargin{1};
end
obj.Property = varargin{2};
obj.OldValue = get_param(varargin{1}, varargin{2});
obj.NewValue = varargin{3};
try
    set_param(varargin{1}, varargin{2}, varargin{3});
catch
    act = 'retry';
    err=lasterror;
    switch err.identifier
        case 'Simulink:SL_DupBlockName'
            parsys=get_param(obj.Handle,'Parent');
            obj.NewValue = gen_unique_name(parsys, obj.NewValue);
        case 'Simulink:SL_LockViolation'
            unlock_library(obj.Handle);
        case {'Simulink:SL_LookupMismatchedParams','Simulink:SL_RowMismatch'}
            act = 'ignore';
        case 'Simulink:SL_BlkParamEvalErr'
            act = 'ignore';
        otherwise
    end
    if strcmp(act, 'retry')
        set_param(varargin{1}, varargin{2}, obj.NewValue);
    end
end
end