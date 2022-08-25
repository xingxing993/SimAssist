function sabt = regblock_argin
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('ArgIn');

sabt.RoutineMethod = 'majorprop_str_num';
sabt.RoutinePattern = '^argin';



sabt.MajorProperty = 'ArgumentName';
sabt.DictRenameMethod = 1; % use major property

sabt.PropagateUpstreamStringMethod = -1;
sabt.PropagateDownstreamStringMethod = 'ArgumentName';
sabt.OutportStringMethod = 'ArgumentName';
sabt.InportStringMethod = -1;

sabt.RefineMethod = @refine_method;
sabt.ColorMethod = {-1, false};

sabt.BlockSize = [100, 14];
sabt.LayoutSize.CharWidth = 6;

sabt.AutoSizeMethod = -2; % leftwards expand to show string

end

function actrec = refine_method(blkhdl)
actrec = saRecorder;
tag = get_param(blkhdl, 'ArgumentName');
newval=sprintf('ArgIn%s_%s',tag, get_param(blkhdl,'Port'));
actrec.SetParamHighlight(blkhdl, 'Name', newval);
end


