function echo = Undo(obj)
echo = [];
switch obj.Type
    case 'set_param'
        obj.undo_set_param;
    case 'set_param_stateflow'
        obj.undo_set_param_stateflow;
    case 'add_block'
        obj.undo_add_block;
    case 'add_line'
        obj.undo_add_line;
    case 'delete_line'
        obj.undo_delete_line;
    case 'replace_block'
        echo.OldHandle = obj.Handle;
        obj.undo_replace_block;
        echo.NewHandle = obj.Handle;
    otherwise
end
end