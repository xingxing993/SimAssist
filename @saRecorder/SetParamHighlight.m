function SetParamHighlight(obj,varargin)
tmrdispparas={};
tmrdispvals={};
objhdl = varargin{1};
for i=2:2:numel(varargin)
    sa = saAction('set_param', objhdl,varargin{i}, varargin{i+1});
    if ~isequal(sa.OldValue,sa.NewValue)
        tmrdispparas=[tmrdispparas;sa.Property];
        tmrdispvals=[tmrdispvals;sa.NewValue];
    end
    obj.PushItem(sa);
end
if ~isempty(tmrdispparas)
    timerdisplay(sa.Handle,tmrdispparas,tmrdispvals);
end
end