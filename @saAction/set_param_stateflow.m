function set_param_stateflow(obj,varargin)
obj.Handle = varargin{1};
obj.Property = varargin{2};
obj.NewValue = varargin{3};
%action
rt=sfroot;
if isnumeric(varargin{1})
    % currently only used for setting inport/outport name
    obj.OldValue = get_param(obj.Handle,'Name');
    sfobj=get_param(obj.Handle,'Object');
    if strcmpi(get_param(obj.Handle,'BlockType'),'Inport')
        sfdata=rt.find('-isa','Stateflow.Data','Scope','Input','Path',sfobj.Path,'Port',str2double(sfobj.Port));
    elseif strcmpi(get_param(obj.Handle,'BlockType'),'Outport')
        sfdata=rt.find('-isa','Stateflow.Data','Scope','Output','Path',sfobj.Path,'Port',str2double(sfobj.Port));
    end
    sfdata.(obj.Property)=obj.NewValue;
else
    sfobj = varargin{1};
    obj.OldValue = sfobj.(obj.Property);
    sfobj.(obj.Property) = obj.NewValue;
end

end