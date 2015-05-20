function echo = Redo(obj)
echo=[]; % feedback
switch obj.Type
    case 'set_param'
        obj.redo_set_param;
    case 'set_param_stateflow'
        obj.redo_set_param_stateflow;
    case 'add_block'
        echo.OldHandle = obj.Handle;
        obj.redo_add_block;
        echo.NewHandle = obj.Handle;
    case 'add_line'
        obj.redo_add_line;
    case 'delete_line'
        obj.redo_delete_line;
    case 'replace_block'
        echo.OldHandle = obj.Handle;
        obj.redo_replace_block;
        echo.NewHandle = obj.Handle;
    otherwise
end
end