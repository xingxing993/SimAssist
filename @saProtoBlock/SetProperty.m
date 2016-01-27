function actrec = SetProperty(obj, blkhdl, propval, nthprop)

if nargin<4
    nthprop = 1;
end

actrec = saRecorder;

setpropmethod = obj.SetPropertyMethod;
if isa(setpropmethod, 'function_handle')
    nn = nargout(setpropmethod);
    if nn~=0 %if mandatory output exist, must be saRecorder
        actrec.Merge(setpropmethod(blkhdl, propval));
    else
        setpropmethod(blkhdl, propval);
    end
elseif isequal(setpropmethod, -1)
    dynmajprop = obj.GetMajorProperty(blkhdl);
    if ~isempty(dynmajprop) && nthprop==1
        actrec.SetParamHighlight(blkhdl, dynmajprop, propval);
    elseif ~isempty(obj.PropertyList)
        actrec.SetParamHighlight(blkhdl, obj.PropertyList{min(nthprop,end)}, propval);
    else
        dlgpstru = get_param(blkhdl,'DialogParameters');
        if isstruct(dlgpstru)
            dlgp = fieldnames(dlgpstru);
            if ~isempty(dlgp)
                actrec.SetParamHighlight(blkhdl, dlgp{min(nthprop, end)}, propval);
            end
        end
    end
end
end