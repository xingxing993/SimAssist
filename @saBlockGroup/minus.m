function obj=minus(obj1,obj2)
obj=saBlockGroup(setdiff(obj1.BlockHandles,obj2.BlockHandles));
end