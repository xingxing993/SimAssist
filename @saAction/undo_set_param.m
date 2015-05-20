function undo_set_param(obj)
try
    set_param(obj.Handle,obj.Property,obj.OldValue);
end
end