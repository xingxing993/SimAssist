function actrec = PropagateUpstreamString(obj, lnhdl)
actrec = saRecorder;
hsrcblk=get_param(lnhdl,'SrcBlockHandle');
hsrcpt=get_param(lnhdl,'SrcPortHandle');
if hsrcblk<0
    return;
elseif ismember(get_param(hsrcblk,'BlockType'),{'Inport','SubSystem'})%Try signal propagate first
    actrec.SetParam(lnhdl,'Name','');
    try
        actrec.SetParam(hsrcpt,'ShowPropagatedSignals','on');
        if isempty(get_param(hsrcpt,'PropagatedSignals'))
            actrec.SetParam(hsrcpt,'ShowPropagatedSignals','off');
            name_got=obj.Console.GetUpstreamString(hsrcpt);
            actrec.SetParam(lnhdl,'Name',name_got);
        end
    catch
        name_got=obj.Console.GetUpstreamString(hsrcpt);
        actrec.SetParam(lnhdl,'Name',name_got);
    end
else
    name_got=obj.Console.GetUpstreamString(hsrcpt);
    actrec.SetParam(lnhdl,'Name',name_got);
end
end