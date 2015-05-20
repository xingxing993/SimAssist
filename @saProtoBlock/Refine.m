function actrec = Refine(obj, blkhdl)

actrec = saRecorder;
if isempty(obj.RefineMethod)
    return;
end

refinemethod = obj.RefineMethod;
if isa(refinemethod, 'function_handle')
    nn = nargout(refinemethod);
    if nn~=0 %if mandatory output exist, must be saRecorder
        actrec.Merge(refinemethod(blkhdl));
    else
        refinemethod(blkhdl);
    end
end

end