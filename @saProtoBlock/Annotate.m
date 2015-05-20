function actrec = Annotate(obj, blkhdl)

actrec = saRecorder;
if isempty(obj.AnnotationMethod)
    return;
end

annomethod = obj.AnnotationMethod;
if isa(annomethod, 'function_handle')
    nn = nargout(annomethod);
    if nn~=0 %if mandatory output exist, must be saRecorder
        actrec.Merge(annomethod(blkhdl));
    else
        annomethod(blkhdl);
    end
elseif isstr(annomethod)
    actrec.SetParam(blkhdl,'AttributesFormatString',annomethod);
else
end


end