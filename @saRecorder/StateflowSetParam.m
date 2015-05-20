function StateflowSetParam(obj,varargin)
sa = saAction('set_param_stateflow', varargin{:});
obj.PushItem(sa);
end