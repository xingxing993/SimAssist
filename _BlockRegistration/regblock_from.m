function sabt = regblock_from
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('From');

sabt.RoutineMethod = 'majorprop_str_num';
sabt.RoutinePattern = '^from';

%bro-block properties
sabt.BroBlockType = {'Goto', 'GotoTagVisibility'};
sabt.CreateBroBlockMethod = -1;
sabt.ConnectPort = [0, 1];


sabt.MajorProperty = 'GotoTag';
sabt.DictRenameMethod = 1; % use major property

sabt.PropagateUpstreamStringMethod = -1;
sabt.PropagateDownstreamStringMethod = 'GotoTag';
sabt.OutportStringMethod = 'GotoTag';
sabt.InportStringMethod = -1;

sabt.RefineMethod = @refine_method;
sabt.ColorMethod = {-1, false};

sabt.BlockSize = [100, 14];
sabt.LayoutSize.CharWidth = 6;

sabt.AutoSizeMethod = -2; % leftwards expand to show string

sabt.GetBroMethod = @saFindBroBlocks;
end

function actrec = refine_method(blkhdl)
actrec = saRecorder;
tag = get_param(blkhdl, 'GotoTag');
newval=[tag,'_',get_param(blkhdl,'BlockType')];
actrec.SetParamHighlight(blkhdl, 'Name', newval);
end


function broblks = get_bro_blocks(blkhdl)
end