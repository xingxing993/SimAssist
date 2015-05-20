function delete_line(obj,varargin)
obj.Handle = varargin{1};
obj.Data.System = get_param(varargin{1}, 'Parent');
obj.Data.Points = get_param(varargin{1}, 'Points');
obj.Data.SrcPort = get_param(varargin{1}, 'SrcPortHandle');
obj.Data.DstPort = get_param(varargin{1}, 'DstPortHandle');
delete_line(obj.Handle);
end