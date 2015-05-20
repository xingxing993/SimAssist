function redo_add_block(obj)
obj.Handle = add_block(obj.Data.Source, obj.Data.Destination, 'MakeNameUnique', 'on', obj.Property{:});
end