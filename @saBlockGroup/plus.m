function obj=plus(obj1,obj2)
obj=saBlockGroup(union(obj1.BlockHandles,obj2.BlockHandles));
end