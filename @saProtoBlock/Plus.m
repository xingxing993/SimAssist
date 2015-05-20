function actrec = Plus(obj, blkhdl, operand)
actrec = saRecorder;
if isempty(obj.PlusMethod)
    return;
else
    bkups = obj.TemporaryCurrentBlockBased(blkhdl); % backup default properties coz port spacing shall be based on current block
    %%%%%%%%%
    if isequal(obj.PlusMethod, -1)
    elseif isa(obj.PlusMethod, 'function_handle')
        nn = nargout(obj.PlusMethod);
        ni = nargin(obj.PlusMethod);
        args = {blkhdl, operand, obj.Console};
        if nn~=0 %if mandatory output exist, must be saRecorder
            actrec.Merge(obj.PlusMethod(args{1:ni}));
        else
            obj.PlusMethod(args{1:ni});
        end
    else
    end
    actrec + obj.AutoSize(blkhdl);
    %%%%%%%%%%
    obj.TemporaryCurrentBlockBased(bkups); % restore original object properties
end
end

