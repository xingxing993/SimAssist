function Redo(obj)
for i=numel(obj.ActionList):-1:1
    echo = obj.ActionList(i).Redo;
    if ~isempty(echo) % update object handle
        bidx = [obj.ActionList.Handle]==echo.OldHandle;
        if any(bidx)
            [obj.ActionList(bidx).Handle]=deal(echo.NewHandle);
        end
    end
end
end