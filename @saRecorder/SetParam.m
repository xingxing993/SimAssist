function SetParam(obj,varargin)
objhdl = varargin{1};
if isstr(objhdl)
    objhdl = get_param(objhdl,'Handle');
end
for i=2:2:numel(varargin)
    sa = saAction('set_param',objhdl, varargin{i}, varargin{i+1});
    obj.PushItem(sa);
end
end