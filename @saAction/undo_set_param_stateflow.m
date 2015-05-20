function undo_set_param_stateflow(obj)
rt=sfroot;
if isnumeric(obj.Handle)
    object=get_param(obj.Handle,'Object');
    if strcmpi(get_param(obj.Handle,'BlockType'),'Inport')
        sfdata=rt.find('Scope','Input','Path',object.Path,'Port',str2num(object.Port));
    elseif strcmpi(get_param(obj.Handle,'BlockType'),'Outport')
        sfdata=rt.find('Scope','Output','Path',object.Path,'Port',str2num(object.Port));
    end
    sfdata.(obj.Property)=obj.OldValue;
else
    object = obj.Handle;
    object.(obj.Property) = obj.OldValue;
end
end