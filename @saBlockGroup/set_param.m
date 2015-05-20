function set_param(objs,varargin)
for kk=1:numel(objs)
    obj=objs(kk);
    for i=1:obj.BlockCount
        set_param(obj.BlockHandles(i),varargin{:});
    end
end
end