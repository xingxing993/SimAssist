function majprop = GetMajorProperty(obj)
if isempty(obj.MajorProperty)
    majprop = '';
elseif isstr(obj.MajorProperty)
    majprop = obj.MajorProperty;
elseif iscell(obj.MajorProperty)
    majprop = obj.MajorProperty{1};
else
end