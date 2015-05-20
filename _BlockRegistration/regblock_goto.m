function sabt = regblock_goto
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Goto');
sabt.RoutineType = 'value_num';
sabt.RoutinePattern = '^goto';

%bro-block properties
sabt.BroBlockType = {'From', 'GotoTagVisibility'};
sabt.CreateBroBlockMethod = -1;
sabt.ConnectPort = [1, 0];

sabt.MajorProperty = 'GotoTag';
sabt.DictRenameMethod = 1; % use major property

sabt.PropagateDownstreamStringMethod = -1;
sabt.PropagateUpstreamStringMethod = 'GotoTag';
sabt.InportStringMethod = 'GotoTag';
sabt.OutportStringMethod = -1;

sabt.AnnotationMethod = 'Scope: %<TagVisibility>';
sabt.RefineMethod = @refine_method;
sabt.ColorMethod = {-1, false};

sabt.BlockSize = [100, 14];
sabt.LayoutSize.CharWidth = 6;

parobj = regblock_datastorewrite;
sabt.Inherit(parobj, 'AutoSizeMethod');

sabt.GetBroMethod = @saFindBroBlocks;
end

function actrec = refine_method(blkhdl)
actrec = saRecorder;
tag = get_param(blkhdl, 'GotoTag');
newval=[tag,'_',get_param(blkhdl,'BlockType')];
actrec.SetParam(blkhdl, 'Name', newval);
end