function Undo(obj)
for i=1:numel(obj.ActionList)
    echo = obj.ActionList(i).Undo;
    if ~isempty(echo) % update object handle
        bidx = [obj.ActionList.Handle]==echo.OldHandle;
        if any(bidx)
            [obj.ActionList(bidx).Handle]=deal(echo.NewHandle);
        end
    end
end
end