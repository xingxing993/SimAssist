function sabt = regblock_argout
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('ArgOut');
sabt.RoutineMethod = 'majorprop_str_num';
sabt.RoutinePattern = '^argout';

sabt.MajorProperty = 'ArgumentName';
sabt.DictRenameMethod = 1; % use major property

sabt.PropagateDownstreamStringMethod = -1;
sabt.PropagateUpstreamStringMethod = 'ArgumentName';
sabt.InportStringMethod = 'ArgumentName';
sabt.OutportStringMethod = -1;

sabt.RefineMethod = @refine_method;
sabt.ColorMethod = {-1, false};

sabt.BlockSize = [100, 14];
sabt.LayoutSize.CharWidth = 6;

end

function actrec = refine_method(blkhdl)
actrec = saRecorder;
tag = get_param(blkhdl, 'ArgumentName');
newval=sprintf('ArgOut%s_%s',tag, get_param(blkhdl,'Port'));
actrec.SetParamHighlight(blkhdl, 'Name', newval);
end