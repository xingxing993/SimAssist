function actrec = ReplaceStr(obj, blkhdl, oldstr, newstr)
%
actrec = saRecorder;

if isempty(obj.StrReplaceMethod)
    return;
elseif isa(obj.StrReplaceMethod, 'function_handle')
    strrep_method = obj.StrReplaceMethod;
    nn = nargout(strrep_method);
    if nn~=0 %if mandatory output exist, must be saRecorder
        actrec.Merge(strrep_method(blkhdl, oldstr, newstr));
    else
        strrep_method(blkhdl, oldstr, newstr);
    end
else % number of string
    if isequal(obj.StrReplaceMethod, 1) || ismember(oldstr, {'^','$'}) % set to 1 to use major property by default
        if ischar(obj.MajorProperty)
            props = cellstr(obj.MajorProperty);
        else
            props={};
        end
    elseif isequal(obj.StrReplaceMethod, -1) % set to -1 to use auto generated string parameter list
        props = saGetStringDialogParameter(blkhdl);
    elseif isequal(obj.StrReplaceMethod, 2)
        props = obj.StrReplaceDefaults;
    elseif ischar(obj.StrReplaceMethod)
        props = cellstr(obj.StrReplaceMethod);
    elseif iscellstr(obj.StrReplaceMethod)
        props = obj.StrReplaceMethod;
    end
    objprops=get_param(blkhdl,'ObjectParameters');
    for k=1:numel(props)
        thisprop = props{k};
        if isfield(objprops, thisprop)
            oldpropstr = get_param(blkhdl, thisprop);
            if strcmp(oldstr, '^') % add prefix
                newpropstr = [newstr, oldpropstr];
            elseif strcmp(oldstr, '$') % append suffix
                newpropstr = [oldpropstr, newstr];
            else
                newpropstr = regexprep(oldpropstr, oldstr, newstr);
            end
            if ~strcmp(oldpropstr, newpropstr)
                actrec.SetParam(blkhdl, thisprop, newpropstr);
            end
        end
    end
end
end