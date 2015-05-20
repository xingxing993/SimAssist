function redo_add_line(obj)
obj.Handle = add_line(obj.Data.System,obj.Data.Points);
set_param(obj.Handle, obj.Property{:});
end