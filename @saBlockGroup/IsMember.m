function bIn=IsMember(obj,block)
bIn=ismember(get_param(block,'Handle'),obj.BlockHandles);
end