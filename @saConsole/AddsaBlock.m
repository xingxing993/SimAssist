function AddsaBlock(obj, sabt)
sabt.Console = obj;
if ~obj.BlockMap.isKey(sabt.MapKey)
    obj.BlockMap(sabt.MapKey) = sabt;
end
end