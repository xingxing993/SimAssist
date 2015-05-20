function redo_set_param(obj)
try
    set_param(obj.Handle,obj.Property,obj.NewValue);
end
end