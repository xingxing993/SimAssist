function actrec = PropagateDownstreamString(obj, lnhdl)
actrec = saRecorder;
hdstpt=get_param(lnhdl,'DstPortHandle');
if hdstpt<0
    return;
else
    for i=1:numel(hdstpt)
        name_got=obj.Console.GetDownstreamString(hdstpt(i));
        if ~isempty(name_got)
            actrec.SetParam(lnhdl,'Name',name_got);
        end
    end
end
end