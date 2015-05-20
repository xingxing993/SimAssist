function actrec = DictRename(obj, blkhdl)
%
actrec = saRecorder;

if isempty(obj.DictRenameMethod)
    return;
elseif isa(obj.DictRenameMethod, 'function_handle')
    dictrename_method = obj.DictRenameMethod;
    nn = nargout(dictrename_method);
    if nn~=0 %if mandatory output exist, must be saRecorder
        actrec.Merge(dictrename_method(blkhdl, obj.Dictionary));
    else
        dictrename_method(blkhdl, obj.Dictionary);
    end
else
    if isequal(obj.DictRenameMethod, 1) % set to 1 to use major property by default
        props = cellstr(obj.MajorProperty);
    elseif isequal(obj.DictRenameMethod, -1) % set to -1 to use auto generated string parameter list
        props = saGetStringDialogParameter(blkhdl);
    else
        props = cellstr(obj.DictRenameMethod);
    end
    objprops=get_param(blkhdl,'ObjectParameters');
    for kk=1:numel(props)
        if isfield(objprops,props{kk})
            valstr=get_param(blkhdl,props{kk});
            newvalstr=saDictRenameString(valstr,obj.Dictionary);
            actrec.SetParam(blkhdl, props{kk}, newvalstr);
        end
    end
end
end