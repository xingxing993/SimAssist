function AddsaBlock(obj, sabt)
sabt.Console = obj;
if ~any(strcmp(obj.BlockMap(:,1),sabt.MapKey))
    obj.BlockMap = [obj.BlockMap; {sabt.MapKey, sabt}];
end
end