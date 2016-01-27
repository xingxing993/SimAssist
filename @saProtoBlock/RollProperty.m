function actrec = RollProperty(obj, blkhdl)

actrec = saRecorder;

rollpropmethod = obj.RollPropertyMethod;
if isequal(rollpropmethod, -1)
    rollpropmethod = obj.GetMajorProperty(blkhdl);
end

if isa(rollpropmethod, 'function_handle')
    nn = nargout(rollpropmethod);
    if nn~=0 %if mandatory output exist, must be saRecorder
        actrec.Merge(rollpropmethod(blkhdl));
    else
        rollpropmethod(blkhdl);
    end
elseif isstr(rollpropmethod)
    dlgparas = get_param(blkhdl,'DialogParameters');
    lst = dlgparas.(rollpropmethod).Enum;
    ik = strmatch(get_param(blkhdl,rollpropmethod), lst, 'exact');
    tmp = rem(ik+1, numel(lst));
    i_next = tmp + (~tmp)*numel(lst);
    valnext=lst{i_next};
    actrec.SetParam(blkhdl,rollpropmethod,valnext);
else
end


end