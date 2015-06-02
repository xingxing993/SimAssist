function add_line(obj, sys, varargin)
% varargin: {points, name} or
%           {srcport, dstport, name}
if isempty(sys)
    sys = gcs;
end
name = '';
if size(varargin{1}, 2)==2 %given points format
    lnpos = varargin{1};
    lnhdl=add_line(sys,lnpos);
    if numel(varargin)>1
        name = varargin{2};
    end
    try % in cases for blocks that outport line cannot be renamed like BusSelector, etc.
        set_param(lnhdl,'Name',name);
    end
else
    [pt1,pt2] = deal(varargin{1:2});
    lnhdl=add_line(sys,pt1,pt2,'autorouting','on');
    lnpos=get_param(lnhdl,'Points');
    if numel(varargin)>2
        name = varargin{3};
    end
    try % in cases for blocks that outport line cannot be renamed like BusSelector, etc.
        set_param(lnhdl,'Name',name);
    end
end
obj.Property = {'Name',name};
obj.Data.System = sys;
obj.Data.Points = lnpos;
obj.Handle = lnhdl;
end