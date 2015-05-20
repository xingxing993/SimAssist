function sabt = regblock_datastorememory
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('DataStoreMemory');
sabt.RoutineType = 'value_num';


%bro-block properties
sabt.BroBlockType = {'DataStoreWrite', 'DataStoreRead'};
sabt.CreateBroBlockMethod = -1;
sabt.ConnectPort = [0, 0];

sabt.MajorProperty = 'DataStoreName';
sabt.DictRenameMethod = 1; % use major property

sabt.PropagateDownstreamStringMethod = 'DataStoreName';
sabt.OutportStringMethod = 'DataStoreName';
sabt.AnnotationMethod = 'DT: %<OutDataTypeStr>';
sabt.RefineMethod = @refine_method;


sabt.BlockSize = [100, 30];
sabt.LayoutSize.CharWidth = 6;

% use the same sizing method with Constant
parobj = regblock_constant;
sabt.Inherit(parobj, 'AutoSizeMethod');

sabt.GetBroMethod = @saFindBroBlocks;
end

function actrec = refine_method(blkhdl)
actrec = saRecorder;
nam = get_param(blkhdl, 'DataStoreName');
actrec.SetParam(blkhdl, 'Name', [nam, '_DataStore']);
end