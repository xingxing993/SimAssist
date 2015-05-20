function obj=BGArrayUnion(objs)
if numel(objs)>=1
    obj=objs(1);
    for i=2:numel(objs)
        obj=obj+objs(i);
    end
end
end