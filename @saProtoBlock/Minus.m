function actrec = Minus(obj, blkhdl, operand)
actrec = saRecorder;
if isempty(obj.MinusMethod)
    return;
else
    if isequal(obj.MinusMethod, -1)
    elseif isa(obj.MinusMethod, 'function_handle')
        nn = nargout(obj.MinusMethod);
        if nn~=0 %if mandatory output exist, must be saRecorder
            actrec.Merge(obj.MinusMethod(blkhdl, operand));
        else
            obj.MinusMethod(blkhdl, operand);
        end
    else
    end
    actrec + obj.AutoSize(blkhdl);
end
end