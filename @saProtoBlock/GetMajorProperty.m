function majprop = GetMajorProperty(obj, blkhdl)
if isempty(obj.MajorProperty)
    majprop = 'Name';
elseif ischar(obj.MajorProperty)
    majprop = obj.MajorProperty;
elseif iscell(obj.MajorProperty)
    majprop = obj.MajorProperty{1};
elseif isnumeric(obj.MajorProperty)
    dlgparas = fieldnames(get_param(blkhdl, 'DialogParameters'));
    if ~isempty(dlgparas)
        if obj.MajorProperty == -1
            majprop = dlgparas{1}; % use the first dialog parameter as major property
        else
            majprop = dlgparas{i}; % use the Nth dialog parameter
        end
    else
        majprop = '';
    end
elseif isa(obj.MajorProperty, 'function_handle')
    getmajpropmethod = obj.MajorProperty;
    majprop = getmajpropmethod(blkhdl);
else
    majprop = 'Name';
end